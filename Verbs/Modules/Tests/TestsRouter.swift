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
    
    func goTo(test: Test) {
        if UserDefaults.shared.bool(for: .favoritesOnly),
           Locator.favorites.verbs.isEmpty {
            showEmptyFavorites()
            return
        }
        
        let nvc = viewController?.navigationController
        let vc = TestAssembly(test: test).viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController ||
           splitViewController?.secondaryViewController?.topViewController is StatisticsViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func goToStatistics() {
        let nvc = viewController?.navigationController
        let vc = StatisticsAssembly().viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController ||
           splitViewController?.secondaryViewController?.topViewController is TestViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
}

// MARK: - Private

private extension TestsRouter {
    
    func showEmptyFavorites() {
        let message: String = .localized(.emptyFavorites)
        let alertController = UIAlertController(title: "empty_favorites_title".localized,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "ok".localized, style: .default))
        viewController?.present(alertController, animated: true)
    }
}
