//
//  FavoritesRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FavoritesRouter {
    
    private weak var navigationController: UINavigationController?
    private weak var splitViewController: UISplitViewController?
    
    init(navigationController: UINavigationController?,
         splitViewController: UISplitViewController?) {
        self.navigationController = navigationController
        self.splitViewController = splitViewController
    }
    
    func goToDetail(with verb: Verb) {
        guard !checkIfAlreadyOpened(by: verb.infinitive.value, in: navigationController) else { return }
        let vc = DetailAssembly(verb: verb,
                                isOpenedByDeeplink: false,
                                navigationController: navigationController).viewController()
        navigationController?.push(vc, in: splitViewController)
    }
}

// MARK: - Private

private extension FavoritesRouter {
    
    func checkIfAlreadyOpened(by title: String, in navigationController: UINavigationController?) -> Bool {
        guard splitViewController?.isCollapsed == false else { return false }
        return splitViewController?.secondaryViewController?.topViewController?.navigationItem.title == title
    }
}
