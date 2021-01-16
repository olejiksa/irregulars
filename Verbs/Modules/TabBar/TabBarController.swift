//
//  TabBarBuilder.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol Scrollable {
    
    func scrollToTop()
}

final class TabBarController: UITabBarController {
        
    init(splitViewController: UISplitViewController?) {
        super.init(nibName: nil, bundle: nil)
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
        
        let listViewController = ListAssembly(splitViewController: svc).viewController().navigationController
        let favoritesViewController = FavoritesAssembly(splitViewController: svc).viewController().navigationController
        let testsViewController = TestsAssembly(splitViewController: svc).viewController().navigationController
        let settingsViewController = SettingsAssembly().viewController().navigationController
        
        compound(items: [(listViewController, "verbs".localized, .bookFill),
                         (favoritesViewController, "favorites".localized, .starFill),
                         (testsViewController, "tests".localized, .puzzleFill),
                         (settingsViewController, "settings".localized, .gearFill)])
    }
    
    func compound(items: [(controller: UIViewController?,
                           title: String,
                           icon: SystemIcon)]) {
        items.enumerated().forEach {
            $1.controller?.tabBarItem = .init(title: $1.title, image: $1.icon.image, tag: $0)
        }
        
        viewControllers = items.map(\.controller).compactMap { $0 }
    }
}
