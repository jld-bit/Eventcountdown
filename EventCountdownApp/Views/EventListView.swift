import SwiftUI
import CoreData

struct EventListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var purchaseManager: PurchaseManager

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \EventItem.date, ascending: true)],
        animation: .default
    )
    private var events: FetchedResults<EventItem>

    @State private var showingEditor = false
    @State private var showingPaywall = false

    private let freeEventLimit = 3

    var body: some View {
        NavigationStack {
            Group {
                if events.isEmpty {
                    ContentUnavailableView(
                        "No Events Yet",
                        systemImage: "calendar.badge.plus",
                        description: Text("Create your first event countdown.")
                    )
                } else {
                    List {
                        ForEach(events) { event in
                            EventCardView(event: event)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteEvents)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Event Countdown")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Upgrade") { showingPaywall = true }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if canCreateMoreEvents {
                            showingEditor = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Label("Add Event", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                EventEditorView(onSave: addEvent)
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .onAppear {
                WidgetSyncManager.sync(upcomingEvent: events.first)
            }
            .onChange(of: events.count) { _, _ in
                WidgetSyncManager.sync(upcomingEvent: events.first)
            }
        }
    }

    private var canCreateMoreEvents: Bool {
        purchaseManager.hasUnlimitedEvents || events.count < freeEventLimit
    }

    private func addEvent(title: String, date: Date, colorHex: String) {
        let newEvent = EventItem(context: viewContext)
        newEvent.id = UUID()
        newEvent.title = title
        newEvent.date = date
        newEvent.createdAt = .now
        newEvent.colorHex = colorHex

        do {
            try viewContext.save()
            NotificationManager.shared.scheduleReminder(for: newEvent)
            WidgetSyncManager.sync(upcomingEvent: events.first)
        } catch {
            print("Failed to save event: \(error.localizedDescription)")
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] }.forEach { event in
                NotificationManager.shared.removeReminder(for: event)
                viewContext.delete(event)
            }
            do {
                try viewContext.save()
                WidgetSyncManager.sync(upcomingEvent: events.first)
            } catch {
                print("Failed to delete event: \(error.localizedDescription)")
            }
        }
    }
}
