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
        let presenter = TestsPresenter(languageService: .init(), hapticService: .init())
        let viewConroller = TestsViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewConroller)
        navigationController.view.backgroundColor = .systemBackground
        let router = TestsRouter(viewController: viewConroller, splitViewController: splitViewController)
        presenter.viewController = viewConroller
        presenter.router = router
        return viewConroller
    }
}
