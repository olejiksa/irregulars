//
//  NavigationController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func push(_ viewController: UIViewController,
              in splitViewController: UISplitViewController? = nil) {
        guard
            let splitViewController = splitViewController,
            splitViewController.traitCollection.horizontalSizeClass == .regular
        else {
            pushViewController(viewController, animated: true)
            return
        }
        
        let secondaryVc = splitViewController.secondaryViewController
        if secondaryVc?.topViewController is SettingsViewController ||
            secondaryVc?.topViewController is TestDetailViewController {
            secondaryVc?.popToRootViewController(animated: false)
        }
        
        secondaryVc?.pushViewController(viewController, animated: true)
    }
}
