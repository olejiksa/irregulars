//
//  TestsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsAssembly: AssemblyProtocol {
    
    private let splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func viewController() -> some TestsViewController {
        let viewModel = TestsViewModel(languageService: .init(), hapticService: .init())
        
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        let router = TestsRouter(viewController: nil, splitViewController: splitViewController)
        
        let viewController = TestsViewController(viewModel: viewModel, router: router)
        navigationController.setViewControllers([viewController], animated: false)
        router.viewController = viewController
        return viewController
    }
}
