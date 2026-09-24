//
//  AppDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import StoreKit
import NotificationCenter

final class AppDelegate: UIResponder {

    private let dependencies: AppDependencies
    private let deeplinkService: DeeplinkService
    
    private var purchaseService: PurchaseService { dependencies.purchaseService }
    
    override init() {
        let dependencies = AppDependencies.shared
        self.dependencies = dependencies
        deeplinkService = DeeplinkService(dependencies: dependencies)
        super.init()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Private

private extension AppDelegate {
    
    /// Used to happen inside the verbs service, which each screen had its own copy of.
    func indexForSpotlight() {
        SpotlightService().setupSpotlight(with: dependencies.catalogue.allVerbs)
    }
    
    func initializePurchaseActivity() {
        Task {
            do {
                await purchaseService.updatePurchasedProducts()
                try await purchaseService.loadProducts()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        initializePurchaseActivity()
        indexForSpotlight()
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse,
                                            withCompletionHandler completionHandler: @escaping Block) {
        let identifier = response.notification.request.identifier
        
        Task { @MainActor in deeplinkService.handle(identifier) }
    }
}
