//
//  ListRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class ListRouter {
    
    private weak var navigationController: UINavigationController?
    private weak var splitViewController: UISplitViewController?
    
    init(navigationController: UINavigationController?,
         splitViewController: UISplitViewController?) {
        self.navigationController = navigationController
        self.splitViewController = splitViewController
    }
    
    func goToDetail(with verb: Verb) {
        guard !checkIfAlreadyOpened(by: verb.infinitive.value) else { return }
        let vc = DetailViewController(verb: verb)
        navigationController?.push(vc, in: splitViewController)
    }
    
    func goToPaywall() {
        let vc = UIHostingController(rootView: PaywallView())
        vc.modalPresentationStyle = .formSheet
        navigationController?.present(vc, animated: true)
    }
}

// MARK: - Private

private extension ListRouter {
    
    func checkIfAlreadyOpened(by title: String) -> Bool {
        guard splitViewController?.isCollapsed == false else { return false }
        return splitViewController?.secondaryViewController?.topViewController?.navigationItem.title == title
    }
}
