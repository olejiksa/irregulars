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
    
    func goToThreeForms() {
        showEmptyFavoritesIfNeeded()
        
        let nvc = viewController?.navigationController
        let vc = TestDetailAssembly().viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func goToSentence() {
        showEmptyFavoritesIfNeeded()
        
        let nvc = viewController?.navigationController
        let vc = SentenceAssembly().viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func showEmptyFavoritesIfNeeded() {
        guard Locator.favorites.verbs.isEmpty else { return }
        
        let alertController = UIAlertController(title: "EmptyFavoritesTitle".localized,
                                                message: "EmptyFavorites".localized,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        viewController?.present(alertController, animated: true)
    }
}
