import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    enum ProductID {
        static let unlimitedEvents = "com.eventcountdown.unlimitedevents"
        static let widgetThemes = "com.eventcountdown.widgetthemes"
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedIDs: Set<String> = []

    var hasUnlimitedEvents: Bool {
        purchasedIDs.contains(ProductID.unlimitedEvents)
    }

    var hasWidgetThemes: Bool {
        purchasedIDs.contains(ProductID.widgetThemes)
    }

    func load() async {
        do {
            products = try await Product.products(for: [ProductID.unlimitedEvents, ProductID.widgetThemes])
            await refreshEntitlements()
        } catch {
            print("Failed to load products: \(error.localizedDescription)")
        }
    }

    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    purchasedIDs.insert(transaction.productID)
                    await transaction.finish()
                case .unverified:
                    break
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error.localizedDescription)")
        }
    }

    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedIDs.insert(transaction.productID)
            }
        }
    }

    private func refreshEntitlements() async {
        purchasedIDs.removeAll()
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedIDs.insert(transaction.productID)
            }
        }
    }
}
