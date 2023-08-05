//
//  TabBarBuilder.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import SwiftUI

protocol Scrollable {
    
    func scrollToTop()
}

final class TabBarController: UITabBarController {
        
    init(splitViewController: UISplitViewController?) {
        super.init(nibName: nil, bundle: nil)
        UITabBar.appearance().scrollEdgeAppearance = .init(idiom: .unspecified)
        build(in: splitViewController)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        guard tabBarController.selectedViewController === viewController,
              let navigationController = viewController as? UINavigationController,
              navigationController.viewControllers.count <= 1,
              let handler = navigationController.viewControllers.first as? Scrollable else { return true }
        handler.scrollToTop()
        
        return true
    }
}

// MARK: - Private

private extension TabBarController {
    
    func build(in splitViewController: UISplitViewController?) {
        guard let svc = splitViewController else { return }
        
        let listViewController = ListAssembly(splitViewController: svc,
                                              favoritesOnly: false).viewController().navigationController
        let favoritesViewController = ListAssembly(splitViewController: svc,
                                                   favoritesOnly: true).viewController().navigationController
        let testsViewController = !FeatureToggle.isNewTestListAvailable
        ? TestsAssembly(splitViewController: svc).viewController().navigationController
        : TestListNewAssembly().viewController
        let settingsViewController = UIHostingController(rootView: SettingsView())
        
        compound(items: [(listViewController, "verbs".localized, .bookFill, .verbsTab),
                         (favoritesViewController, "favorites".localized, .starFill, .favoritesTab),
                         (testsViewController, "tests".localized, .puzzleFill, .testsTab),
                         (settingsViewController, "settings".localized, .gearFill, .settingsTab)])
    }
    
    func compound(items: [(controller: UIViewController?,
                           title: String,
                           icon: SystemIcon,
                           accessibilityIdentifier: AccessibilityIdentifier)]) {
        items.enumerated().forEach {
            let tabBarItem = UITabBarItem(title: $1.title, image: $1.icon.image, tag: $0)
            tabBarItem.accessibilityIdentifier = $1.accessibilityIdentifier.rawValue
            $1.controller?.tabBarItem = tabBarItem
        }
        
        viewControllers = items.map(\.controller).compactMap { $0 }
    }
}
