//
//  TestDetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestDetailAssembly: AssemblyProtocol {
    
    private let index: Int
    private let items: [String]
    private let navigationController: UINavigationController?

    init(index: Int,
         items: [String],
         navigationController: UINavigationController?) {
        self.index = index
        self.items = items
        self.navigationController = navigationController
    }
    
    func viewController() -> some TestDetailViewController {
        let presenter = TestDetailPresenter(items: items,
                                            audioService: .init(),
                                            verbsService: .init(),
                                            rateService: .init())
        let viewController = TestDetailViewController(index: index, presenter: presenter)
        let router = TestDetailRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
