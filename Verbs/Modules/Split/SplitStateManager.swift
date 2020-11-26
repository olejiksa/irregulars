//
//  SplitStateManager.swift
//  Verbs
//
//  Created by Oleg Samoylov on 27.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitStateManager: UISplitViewControllerDelegate {
    
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        guard let compactViewController = svc.compactViewController else { return }
        
        let tabBarItem = TabBarItem(rawValue: compactViewController.selectedIndex) ?? .all
        
        switch tabBarItem {
        case .all, .favorites, .tests:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                svc.sidebarViewController?.restore(at: .init(row: tabBarItem.rawValue + 1, section: 0))
            }
        case .settings:
            break
        }
        
        svc.secondaryViewController?.popToRootViewController(animated: false)
        
        let navigationController = compactViewController.selectedViewController as? UINavigationController
        if let viewController = navigationController?.topViewController, viewController is Restorable {
            (viewController as? Restorable)?.restore()
            svc.secondaryViewController?.pushViewController(viewController, animated: true)
        }
    }
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        guard let supplementaryViewController = svc.supplementaryViewController,
              let secondaryViewController = svc.secondaryViewController?.topViewController,
              let tabBarItem = TabBarItem(supplementary: supplementaryViewController,
                                          secondary: secondaryViewController) else { return }
        
        svc.compactViewController?.selectedIndex = tabBarItem.rawValue
        clearTabBarNavigationStack(in: svc)
        
        guard secondaryViewController is Restorable else { return }
        (secondaryViewController as? Restorable)?.restore()
        
        switch secondaryViewController {
        case is SettingsViewController:
            let navigationController = UINavigationController(rootViewController: secondaryViewController)
            navigationController.tabBarItem = .init(title: "Settings".localized, image: SystemIcon.gear.image, tag: 3)
            svc.compactViewController?.viewControllers?[tabBarItem.rawValue] = navigationController
        case is Restorable:
            let nvc = svc.compactViewController?.selectedViewController as? UINavigationController
            nvc?.pushViewController(secondaryViewController, animated: false)
        default:
            break
        }
    }
}

// MARK: - Private

private extension SplitStateManager {
    
    func clearTabBarNavigationStack(in svc: UISplitViewController) {
        guard let viewControllers = svc.compactViewController?.viewControllers else { return }
        
        for case let navigationController as UINavigationController in viewControllers {
            navigationController.isNavigationBarHidden = true
            navigationController.popToRootViewController(animated: true)
            navigationController.isNavigationBarHidden = false
        }
    }
}
