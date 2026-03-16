import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            List {
                Section("Premium") {
                    premiumRow(
                        title: "Unlimited Events",
                        subtitle: "Create as many countdowns as you want.",
                        unlocked: purchaseManager.hasUnlimitedEvents
                    )

                    premiumRow(
                        title: "Widget Themes",
                        subtitle: "Unlock extra visual styles in the widget.",
                        unlocked: purchaseManager.hasWidgetThemes
                    )
                }

                Section("Products") {
                    ForEach(purchaseManager.products, id: \.id) { product in
                        Button {
                            Task { await purchaseManager.purchase(product) }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.displayName)
                                    Text(product.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice).bold()
                            }
                        }
                        .disabled(purchaseManager.purchasedIDs.contains(product.id))
                    }
                }

                Button("Restore Purchases") {
                    Task { await purchaseManager.restorePurchases() }
                }
            }
            .navigationTitle("Upgrade")
        }
        .task {
            await purchaseManager.load()
        }
    }

    private func premiumRow(title: String, subtitle: String, unlocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).bold()
                Spacer()
                Image(systemName: unlocked ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundStyle(unlocked ? .green : .secondary)
            }
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
