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
import YandexMobileMetrica

@UIApplicationMain
final class AppDelegate: UIResponder {

    private let analyticsService = AnalyticsService()
    private let deeplinkService = DeeplinkService()
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
        analyticsService.start()
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping Block) {
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as? SceneDelegate
        guard let splitViewController = sd?.window?.rootViewController as? SplitViewController else { return }
        deeplinkService.handle(response.notification.request.identifier,
                               in: splitViewController)
    }
}
