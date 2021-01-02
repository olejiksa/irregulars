//
//  PurchaseService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import StoreKit

final class PurchaseService: NSObject {
    
    typealias ErrorHandler = (Error?) -> ()
    
    private let proID = "com.olejiksa.Verbs.Pro"
    
    private var products: [SKProduct] = []
    private var productsRequest: SKProductsRequest?
    private var activationHandler: Block?
    private var priceHandler: StringBlock?
    private var errorHandler: ErrorHandler?
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var canMakePayments: Bool { SKPaymentQueue.canMakePayments() }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func fetchPrice(priceHandler: @escaping StringBlock) {
        productsRequest?.cancel()
        
        self.activationHandler = nil
        self.priceHandler = priceHandler
        self.errorHandler = nil
        
        productsRequest = SKProductsRequest(productIdentifiers: [proID])
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func requestProducts(activationHandler: @escaping Block,
                         errorHandler: @escaping ErrorHandler) {
        productsRequest?.cancel()
        
        self.activationHandler = activationHandler
        self.priceHandler = nil
        self.errorHandler = errorHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: [proID])
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func buy() {
        guard let product = products.first else { return }
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - Private

private extension PurchaseService {
    
    func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotification()
        SKPaymentQueue.default().finishTransaction(transaction)
        
        activationHandler?()
    }
    
    func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotification()
        SKPaymentQueue.default().finishTransaction(transaction)
        
        activationHandler?()
    }
    
    func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        
        guard let nsError = transaction.error as NSError? else {
            errorHandler?(transaction.error)
            return
        }
        
        let error = SKError(_nsError: nsError)
        switch error {
        case SKError.paymentCancelled:
            let paymentCancelled = PurchaseError.paymentCancelled
            errorHandler?(paymentCancelled)
        default:
            errorHandler?(transaction.error)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func deliverPurchaseNotification() {
        FeatureToggle.isPaid = true
    }
    
    func clearRequest() {
        productsRequest = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension PurchaseService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - SKProductsRequestDelegate

extension PurchaseService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest,
                         didReceive response: SKProductsResponse) {
        products = response.products
        errorHandler?(nil)
        clearRequest()
        
        for product in products {
            print("Found product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
            guard let price = priceFormatter.string(from: product.price) else { continue }
            priceHandler?(price)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        errorHandler?(error)
        clearRequest()
    }
}
