//
//  PurchaseService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 7/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import StoreKit

@MainActor
final class PurchaseService: ObservableObject {
    
    var canMakePayments: Bool {
        AppStore.canMakePayments
    }
    
    private let productIDs = ["com.olejiksa.Verbs.Pro"]
    
    @Published
    private(set) var products: [Product] = []
    
    private var purchasedProductIDs = Set<String>()
    private var areProductsLoaded = false
    private var updates: Task<Void, Never>? = nil
    private var purchaseIntents: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
        purchaseIntents = observePurchaseIntents()
    }
    
    deinit {
        updates?.cancel()
        purchaseIntents?.cancel()
    }
    
    func loadProducts() async throws {
        guard !areProductsLoaded else { return }
        products = try await Product.products(for: productIDs)
        areProductsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            await updatePurchasedProducts()
        case .success(.unverified):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            process(verificationResult: result)
        }
        
        FeatureToggle.isPaid = !purchasedProductIDs.isEmpty
    }
}

// MARK: - Private

private extension PurchaseService {
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.updatePurchasedProducts()
            }
        }
    }
    
    /// Handles the purchases started from the App Store product page,
    /// which StoreKit 1 delivered through `shouldAddStorePayment`.
    func observePurchaseIntents() -> Task<Void, Never> {
        Task { [weak self] in
            for await intent in PurchaseIntent.intents {
                try? await self?.purchase(intent.product)
            }
        }
    }
    
    func process(verificationResult: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = verificationResult else {
            return
        }
        
        if transaction.revocationDate == nil {
            purchasedProductIDs.insert(transaction.productID)
        } else {
            purchasedProductIDs.remove(transaction.productID)
        }
    }
}
