//
//  SceneDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

/// SwiftUI owns the window; this is only here for what a scene delegate can still do
/// better, which is the home screen shortcuts and the Mac window.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let deeplinkService = DeeplinkService(dependencies: .shared)
    private var shortcutItemToProcess: UIApplicationShortcutItem?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        shortcutItemToProcess = connectionOptions.shortcutItem
        tidyCatalystWindow()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(name: .reload, object: nil, userInfo: [:])
        
        guard let shortcutItem = shortcutItemToProcess, let windowScene = scene as? UIWindowScene else { return }
        
        self.windowScene(windowScene, performActionFor: shortcutItem) { [weak self] _ in
            self?.shortcutItemToProcess = nil
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
            deeplinkService.search(text: "")
        case .favorites:
            deeplinkService.favorites()
        case .tests:
            deeplinkService.tests()
        case .statistics:
            deeplinkService.statistics()
        }
        
        completionHandler(true)
    }
}

// MARK: - Private

private extension SceneDelegate {
    
    func tidyCatalystWindow() {
        #if targetEnvironment(macCatalyst)
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .forEach { windowScene in
                let size = CGSize(width: 1280 + 182 + 43 + 12, height: 800)
                windowScene.sizeRestrictions?.minimumSize = size
                windowScene.sizeRestrictions?.maximumSize = size
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    windowScene.sizeRestrictions?.maximumSize = size
                }
            }
        #endif
    }
}
