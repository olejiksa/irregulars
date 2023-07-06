//
//  PaywallViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 7/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import StoreKit

@MainActor
final class PaywallViewModel: ObservableObject {
    
    private let analyticsService = AnalyticsService()
    private let hapticService = HapticService()
    
    @Published
    var purchaseService = PurchaseService()
    
    @Published
    var isBuyingPurchaseNotInProgress = true
    
    @Published
    var isRestoringPurchaseNotInProgress = true
    
    let title: String
    
    init() {
        title = Bundle.main.productName.map { "\($0) Pro" } ?? ""
        analyticsService.send(event: .paywallOpened)
    }
    
    var canMakePayments: Bool {
        purchaseService.canMakePayments
    }
    
    func buy(product: Product, dismiss: @escaping Block) {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            dismiss()
            return
        }
        
        Task { [weak self] in
            self?.isBuyingPurchaseNotInProgress = false
            
            do {
                try await self?.purchaseService.purchase(product)
                FeatureToggle.isPaid = true
            } catch {
                self?.hapticService.generateHapticFeedback(for: .notification(.error))
                // self.router?.show(error: error)
            }
            
            self?.isBuyingPurchaseNotInProgress = true
        }
        
        analyticsService.send(event: .paywallBuyTapped)
    }
    
    func restore(dismiss: @escaping Block) {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            dismiss()
            return
        }
        
        Task { [weak self] in
            self?.isRestoringPurchaseNotInProgress = false
            
            do {
                try await self?.purchaseService.restorePurchases()
            } catch {
                self?.hapticService.generateHapticFeedback(for: .notification(.error))
                // self.router?.show(error: error)
            }
            
            self?.isRestoringPurchaseNotInProgress = true
        }
    }
}
