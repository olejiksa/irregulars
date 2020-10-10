//
//  SplitViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        preferredPrimaryColumnWidthFraction = 0.5
        maximumPrimaryColumnWidth = 2_000
    }
}

// MARK: - UISplitViewControllerDelegate

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             showDetail vc: UIViewController,
                             sender: Any?) -> Bool {
        let nvc = splitViewController.viewControllers.last as? UINavigationController
        nvc?.pushViewController(vc, animated: true)
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let navigationController = secondaryViewController as? UINavigationController else { return true }
        return navigationController.viewControllers.last is EmptyViewController
    }
    
    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        guard
            let primaryNavigationController = splitViewController.viewControllers.first as? UINavigationController,
            let secondaryNavigationController = splitViewController.viewControllers.last as? UINavigationController,
            let secondaryViewController = secondaryNavigationController.viewControllers.last,
            !(secondaryViewController is EmptyViewController)
        else { return nil }
        
        secondaryNavigationController.popToRootViewController(animated: false)
        primaryNavigationController.pushViewController(secondaryViewController, animated: false)
        return primaryNavigationController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard
            let primaryNavigationController = splitViewController.viewControllers.first as? UINavigationController,
            let detailViewController = primaryNavigationController.viewControllers.last as? DetailViewController
        else { return nil }
        
        detailViewController.navigationController?.delegate = detailViewController
        primaryNavigationController.popToRootViewController(animated: false)
        let emptyVc = EmptyViewController()
        let nvc = UINavigationController(rootViewController: emptyVc)
        nvc.pushViewController(detailViewController, animated: false)
        return nvc
    }
}
