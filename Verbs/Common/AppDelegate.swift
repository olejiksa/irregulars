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

    private let deeplinkService = DeeplinkService(router: .shared)
    private let menuService = MenuService()
    private let printService = PrintService()
    private let purchaseService = Locator.purchaseService
    private let verbsService = VerbsService()
    private let languageService = LanguageService()
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        menuService.buildMenu(with: builder)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let canPerform = super.canPerformAction(action, withSender: sender)
        let menuCanPerform = menuService.canPerformAction(action, with: sender)
        return canPerform || menuCanPerform
    }
    
    @objc func printFile() {
        printService.print(verbsService.items, hasTranslation: languageService.hasTranslation)
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
    
    func registerSettings() {
        UserDefaults.shared.register(true, for: .regularVerbs)
        UserDefaults.shared.register(true, for: .regularVerbsTests)
        UserDefaults.shared.register(true, for: .derivatives)
        UserDefaults.shared.register(true, for: .derivativesTests)
        UserDefaults.shared.register(2, for: .playbackSpeed)
        UserDefaults.shared.register(1, for: .frequency)
        UserDefaults.shared.register(540, for: .since)
        UserDefaults.shared.register(1260, for: .to)
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
        registerSettings()
        UNUserNotificationCenter.current().delegate = self
        initializePurchaseActivity()
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
