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
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func viewController() -> some ListViewController {
        let presenter = ListPresenter(languageService: .init(),
                                      verbsService: VerbsService(),
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
