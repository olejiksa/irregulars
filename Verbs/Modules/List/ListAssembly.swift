//
//  ListAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListAssembly {
    
    typealias ViewController = ListViewController
    
    private let splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func viewController() -> ViewController {
        let presenter = ListPresenter(languageService: .init(),
                                      verbsService: .init(),
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
