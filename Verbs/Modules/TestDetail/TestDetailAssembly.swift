//
//  TestDetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestDetailAssembly: AssemblyProtocol {
    
    private let items: [String]
    private let navigationController: UINavigationController?

    init(items: [String],
         navigationController: UINavigationController?) {
        self.items = items
        self.navigationController = navigationController
    }
    
    func viewController() -> some TestDetailViewController {
        let presenter = TestDetailPresenter(items: items,
                                            audioService: .init(),
                                            verbsService: .init())
        let router = DetailRouter(navigationController: navigationController)
        let viewConroller = TestDetailViewController(presenter: presenter)
        presenter.viewController = viewConroller
        presenter.router = router
        return viewConroller
    }
}
