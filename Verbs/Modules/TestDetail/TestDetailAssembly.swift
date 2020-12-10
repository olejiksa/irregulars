//
//  TestDetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestDetailAssembly: AssemblyProtocol {
    
    func viewController() -> some TestDetailViewController {
        let presenter = TestDetailPresenter(audioService: .init(),
                                            verbsService: .init(),
                                            favoritesService: .init(),
                                            languageService: .init())
        let viewController = TestDetailViewController(presenter: presenter)
        let router = TestDetailRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
