//
//  ListAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListAssembly {
    
    func viewController(with splitViewController: UISplitViewController) -> ListViewController {
        let presenter = ListPresenter(verbsService: .init(),
                                      userDefaultsService: .init())
        let viewController = ListViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        let router = ListRouter(navigationController: navigationController,
                                splitViewController: splitViewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
