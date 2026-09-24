//
//  PaywallViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 7/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation
import StoreKit

@MainActor
@Observable
final class PaywallViewModel {
    
    private let hapticService = HapticService()
    
    var purchaseService = Locator.purchaseService
    
    var isBuyingPurchaseNotInProgress = true
    
    var isRestoringPurchaseNotInProgress = true
    
    let title: String
    
    init() {
        title = Bundle.main.productName.map { "\($0) Pro" } ?? ""
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
            } catch {
                self?.hapticService.generateHapticFeedback(for: .notification(.error))
                print(error)
                // self.router?.show(error: error)
            }
            
            self?.isBuyingPurchaseNotInProgress = true
        }
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
                print(error)
                // self.router?.show(error: error)
            }
            
            self?.isRestoringPurchaseNotInProgress = true
        }
    }
}
