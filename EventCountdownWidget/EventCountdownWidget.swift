import WidgetKit
import SwiftUI

private enum WidgetKeys {
    static let appGroupID = "group.com.eventcountdown.shared"
    static let keyTitle = "widget_next_title"
    static let keyDate = "widget_next_date"
    static let keyColorHex = "widget_next_color"
}

private extension Color {
    init(hex: String) {
        let sanitized = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        self.init(
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255
        )
    }
}

private struct EventEntry: TimelineEntry {
    let date: Date
    let title: String
    let eventDate: Date?
    let colorHex: String
}

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> EventEntry {
        EventEntry(date: .now, title: "Sample Event", eventDate: .now.addingTimeInterval(86_400), colorHex: "#3B82F6")
    }

    func getSnapshot(in context: Context, completion: @escaping (EventEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: .now) ?? .now.addingTimeInterval(60)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadEntry() -> EventEntry {
        guard let defaults = UserDefaults(suiteName: WidgetKeys.appGroupID) else {
            return EventEntry(date: .now, title: "No Upcoming Event", eventDate: nil, colorHex: "#8B5CF6")
        }

        let title = defaults.string(forKey: WidgetKeys.keyTitle) ?? "No Upcoming Event"
        let timestamp = defaults.double(forKey: WidgetKeys.keyDate)
        let eventDate = timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
        let colorHex = defaults.string(forKey: WidgetKeys.keyColorHex) ?? "#8B5CF6"

        return EventEntry(date: .now, title: title, eventDate: eventDate, colorHex: colorHex)
    }
}

private struct EventCountdownWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: entry.colorHex).gradient)

            VStack(alignment: .leading, spacing: 8) {
                Text("Next Event")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.85))
                Text(entry.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                if let eventDate = entry.eventDate {
                    let parts = Calendar.current.dateComponents([.day, .hour, .minute], from: .now, to: eventDate)
                    Text("\(max(parts.day ?? 0, 0))d \(max(parts.hour ?? 0, 0))h \(max(parts.minute ?? 0, 0))m")
                        .font(.title3.bold())
                        .monospacedDigit()
                        .foregroundStyle(.white)
                } else {
                    Text("Add an event in the app")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding()
        }
    }
}

struct EventCountdownWidget: Widget {
    let kind: String = "EventCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EventCountdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Event Countdown")
        .description("Shows your next upcoming event.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
