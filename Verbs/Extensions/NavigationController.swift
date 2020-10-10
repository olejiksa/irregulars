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
            !splitViewController.isCollapsed
        else {
            pushViewController(viewController, animated: true)
            return
        }
        
        splitViewController.showDetailViewController(viewController, sender: self)
    }
}
