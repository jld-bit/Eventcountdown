import SwiftUI

@main
struct EventCountdownApp: App {
    private let persistenceController = PersistenceController.shared
    @StateObject private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            EventListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(purchaseManager)
                .task {
                    await NotificationManager.shared.requestAuthorization()
                    await purchaseManager.load()
                }
        }
    }
}
