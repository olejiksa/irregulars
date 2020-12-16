//
//  SceneDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

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
        
        UserDefaults.shared.register(true, for: .shouldRegularVerbsBeShown)
        UserDefaults.shared.register(true, for: .shouldDerivedFormsBeShown)
        UserDefaults.shared.register(2, for: .playbackSpeed)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splitViewController
        window?.tintColor = AccentColor.current.color
        window?.makeKeyAndVisible()
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let context = URLContexts.first,
            let host = context.url.host
        else { return }
        
        deeplinkService.handle(host, in: splitViewController)
    }
}
