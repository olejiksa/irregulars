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

    private let deeplinkService = DeeplinkService()
    private let menuService = MenuService()
    
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
        let printService = PrintService()
        let verbsService = VerbsService()
        let languageService = LanguageService()
        printService.print(verbsService.items, hasTranslation: languageService.hasTranslation)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SKPaymentQueue.default().add(Locator.purchaseService)
        UNUserNotificationCenter.current().delegate = self
        AnalyticsService().start()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(Locator.purchaseService)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as? SceneDelegate
        guard let splitViewController = sd?.window?.rootViewController as? SplitViewController else { return }
        deeplinkService.handle(response.notification.request.identifier,
                               in: splitViewController)
    }
}
