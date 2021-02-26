//
//  ListAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListAssembly {
    
    private let splitViewController: UISplitViewController
    private let favoritesOnly: Bool
    
    init(splitViewController: UISplitViewController, favoritesOnly: Bool) {
        self.splitViewController = splitViewController
        self.favoritesOnly = favoritesOnly
    }
    
    func viewController() -> some ListViewController {
        let verbsService: VerbsServiceProtocol = favoritesOnly ? Locator.favoritesService : VerbsService()
        let presenter = ListPresenter(languageService: .init(),
                                      verbsService: verbsService,
                                      printService: .init())
        let viewController = ListViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = .systemBackground
        let router = ListRouter(navigationController: navigationController,
                                splitViewController: splitViewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
