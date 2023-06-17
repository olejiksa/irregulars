//
//  SceneDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import CoreSpotlight
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let deeplinkService = DeeplinkService()
    private var shortcutItemToProcess: UIApplicationShortcutItem?
    
    private lazy var splitViewController: UISplitViewController = {
        let splitViewController = SplitViewController()
        let sidebarViewController = SidebarAssembly().viewController()
        let sidebarNavigationController = UINavigationController(rootViewController: sidebarViewController)
        let supplementaryViewController = ListAssembly(splitViewController: splitViewController,
                                                       favoritesOnly: false).viewController()
        let secondaryViewController = EmptyViewController()
        let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)
        let tabbarViewController = TabBarController(splitViewController: splitViewController)
        splitViewController.primaryBackgroundStyle = .sidebar
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
        
        #if !targetEnvironment(macCatalyst)
        window?.tintColor = AccentColor.current.color
        #endif

        window?.makeKeyAndVisible()
        
        shortcutItemToProcess = connectionOptions.shortcutItem
        openOnboardingIfNeeded()
        runOnMac(scene, options: connectionOptions)
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
        NotificationCenter.default.post(name: .reload, object: nil, userInfo: [:])
        
        if let shortcutItem = shortcutItemToProcess {
            guard let windowScene = scene as? UIWindowScene else { return }
            self.windowScene(windowScene, performActionFor: shortcutItem) { [weak self] _ in
                self?.shortcutItemToProcess = nil
            }
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        guard let shortcut = AppShortcut(rawValue: shortcutItem.type) else {
            completionHandler(false)
            return
        }
        
        switch shortcut {
        case .search:
            deeplinkService.search(text: "", in: splitViewController)
        case .favorites:
            deeplinkService.favorites(in: splitViewController)
        case .tests:
            deeplinkService.tests(in: splitViewController)
        case .statistics:
            deeplinkService.statistics(in: splitViewController)
        }
        
        completionHandler(true)
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
        UserDefaults.shared.register(1, for: .frequency)
        UserDefaults.shared.register(540, for: .since)
        UserDefaults.shared.register(1260, for: .to)
    }
    
    func openOnboardingIfNeeded() {
        guard FeatureToggle.isOnboardingAvailable else { return }
        let view = OnboardingView()
        let viewController = UIHostingController(rootView: view)
        window?.rootViewController?.present(viewController, animated: true)
    }
    
    func runOnMac(_ scene: UIScene, options connectionOptions: UIScene.ConnectionOptions) {
#if DEBUG
if CommandLine.arguments.contains("dark") {
    window?.overrideUserInterfaceStyle = .dark
}

guard let accentColorString = ProcessInfo.processInfo.environment["accent-color"],
      let accentColor = AccentColor(rawValue: accentColorString)
else { return }

AccentColor.current = accentColor
window?.tintColor = accentColor.color
#endif

self.scene(scene, openURLContexts: connectionOptions.urlContexts)
for userActivity in connectionOptions.userActivities {
    self.scene(scene, continue: userActivity)
}

#if targetEnvironment(macCatalyst)
if let titlebar = windowScene.titlebar {
    titlebar.titleVisibility = .hidden
    titlebar.toolbar = nil
}
#endif
    }
}
