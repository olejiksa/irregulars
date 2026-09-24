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
    
    @MainActor
    func viewController() -> some ListViewController {
        let verbsService: VerbsServiceProtocol = favoritesOnly ? Locator.favoritesService : VerbsService()
        let viewModel = ListViewModel(languageService: .init(),
                                      verbsService: verbsService,
                                      printService: .init())
        
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        let router = ListRouter(navigationController: navigationController,
                                splitViewController: splitViewController)
        
        let viewController = ListViewController(viewModel: viewModel, router: router)
        navigationController.setViewControllers([viewController], animated: false)
        return viewController
    }
}
