//
//  TestAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestAssembly: AssemblyProtocol {
    
    private let test: Test
    
    init(test: Test) {
        self.test = test
    }
    
    func viewController() -> some TestViewController {
        let itemsFactory = TestItemsFactory(languageService: .init(),
                                            sentencesService: .init(),
                                            verbsService: .init())
        let presenter = TestPresenter(audioService: .init(),
                                      verbsService: .init(),
                                      favoritesService: Locator.favoritesService,
                                      itemsFactory: itemsFactory,
                                      test: test)
        let viewController = TestViewController(presenter: presenter, title: test.title)
        let router = TestRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
