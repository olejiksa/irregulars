//
//  SceneDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreSpotlight

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let deeplinkService = DeeplinkService()
    
    private lazy var splitViewController: UISplitViewController = {
        let splitViewController = SplitViewController()
        let sidebarViewController = SidebarAssembly().viewController()
        let sidebarNavigationController = UINavigationController(rootViewController: sidebarViewController)
        let supplementaryViewController = ListAssembly(splitViewController: splitViewController).viewController()
        let secondaryViewController = EmptyViewController()
        let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)
        let tabbarViewController = TabBarController(splitViewController: splitViewController)
        splitViewController.setViewController(sidebarNavigationController, for: .primary)
        splitViewController.setViewController(supplementaryViewController.navigationController, for: .supplementary)
        splitViewController.setViewController(secondaryNavigationController, for: .secondary)
        splitViewController.setViewController(tabbarViewController, for: .compact)
        return splitViewController
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        registerSettings()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splitViewController
        window?.tintColor = AccentColor.current.color
        window?.makeKeyAndVisible()
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        for userActivity in connectionOptions.userActivities {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let context = URLContexts.first,
            let host = context.url.host
        else { return }
        
        deeplinkService.handle(host, in: splitViewController)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == CSSearchableItemActionType,
           let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            let infinitive = identifier.split(separator: ".").last ?? ""
            deeplinkService.handle(String(infinitive), in: splitViewController)
        } else if let searchText = userActivity.userInfo?[CSSearchQueryString] as? String {
            deeplinkService.search(text: searchText, in: splitViewController)
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(name: .reload,
                                        object: nil,
                                        userInfo: [:])
    }
}

// MARK: - Private

private extension SceneDelegate {
    
    func registerSettings() {
        UserDefaults.shared.register(true, for: .regularVerbs)
        UserDefaults.shared.register(true, for: .regularVerbsTests)
        UserDefaults.shared.register(true, for: .derivatives)
        UserDefaults.shared.register(true, for: .derivativesTests)
        UserDefaults.shared.register(2, for: .playbackSpeed)
    }
}
