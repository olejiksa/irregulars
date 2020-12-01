//
//  TestsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 22.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsRouter {
    
    private weak var viewController: UIViewController?
    private weak var splitViewController: UISplitViewController?
    
    init(viewController: UIViewController?,
         splitViewController: UISplitViewController?) {
        self.viewController = viewController
        self.splitViewController = splitViewController
    }
    
    func goToPaywall() {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
    
    func goToDetail(test: Test, items: [String]) {
        let nvc = viewController?.navigationController
        let vc = TestDetailAssembly(test: test,
                                    items: items,
                                    navigationController: nvc).viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "EmptyFavoritesError".localized,
                                                message: "EmptyFavorites".localized,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        viewController?.present(alertController, animated: true)
    }
}
