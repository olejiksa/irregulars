//
//  TestsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 22.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

@MainActor
final class TestsRouter {
    
    private weak var viewController: UIViewController?
    private weak var splitViewController: UISplitViewController?
    
    init(viewController: UIViewController?,
         splitViewController: UISplitViewController?) {
        self.viewController = viewController
        self.splitViewController = splitViewController
    }
    
    func goToPaywall() {
        let vc = UIHostingController(rootView: PaywallView())
        vc.modalPresentationStyle = .formSheet
        viewController?.present(vc, animated: true)
    }
    
    func goTo(test: Test) {
        let nvc = viewController?.navigationController
        let vc = TestAssembly(test: test).viewController()
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController ||
            splitViewController?.secondaryViewController?.topViewController is UIHostingController<StatisticsView> {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func goToStatistics() {
        let nvc = viewController?.navigationController
        let vc = UIHostingController(rootView: StatisticsView())
        if splitViewController?.secondaryViewController?.topViewController is DetailViewController ||
           splitViewController?.secondaryViewController?.topViewController is TestViewController {
            splitViewController?.secondaryViewController?.popToRootViewController(animated: false)
        }
        nvc?.push(vc, in: splitViewController)
    }
    
    func showEmptyFavorites() {
        let message: String = .localized(.emptyFavorites)
        let alertController = UIAlertController(title: "empty_favorites_title".localized,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "ok".localized, style: .default))
        viewController?.present(alertController, animated: true)
    }
}
