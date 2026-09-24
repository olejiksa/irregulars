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
    
    
    var purchaseService: PurchaseService
    
    var isBuyingPurchaseNotInProgress = true
    
    var isRestoringPurchaseNotInProgress = true
    
    /// Bumped to ask the view for a haptic tap.
    private(set) var errorFeedback = 0
    
    let title: String
    
    init(purchaseService: PurchaseService) {
        self.purchaseService = purchaseService
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
                self?.errorFeedback += 1
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
                self?.errorFeedback += 1
                print(error)
                // self.router?.show(error: error)
            }
            
            self?.isRestoringPurchaseNotInProgress = true
        }
    }
}
