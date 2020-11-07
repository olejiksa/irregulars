//
//  TabBarController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 07.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol Scrollable {
    
    func scrollToTop()
}

final class TabBarController: UITabBarController {
    
    private weak var previousController: UIViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
