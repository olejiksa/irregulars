//
//  AppDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import StoreKit
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SKPaymentQueue.default().add(Locator.purchaseService)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(Locator.purchaseService)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
