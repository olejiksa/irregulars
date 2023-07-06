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
    
    private var areProductsLoaded = false
    
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
    }
}
