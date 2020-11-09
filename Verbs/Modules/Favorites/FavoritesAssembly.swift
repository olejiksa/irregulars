//
//  FavoritesAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FavoritesAssembly: AssemblyProtocol {
    
    typealias ViewController = FavoritesViewController
    
    private let splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func viewController() -> ViewController {
        let presenter = FavoritesPresenter(languageService: .init(),
                                           favoritesService: Locator.favoritesService,
                                           userDefaultsService: .init())
        let viewController = FavoritesViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        let router = FavoritesRouter(navigationController: navigationController,
                                     splitViewController: splitViewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
