//
//  StatisticsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsAssembly: AssemblyProtocol {
    
    func viewController() -> some StatisticsViewController {
        let presenter = StatisticsPresenter(languageService: .init(),
                                            hapticService: .init(),
                                            verbsService: .init())
        let viewConroller = StatisticsViewController(presenter: presenter)
        let router = StatisticsRouter(viewController: viewConroller)
        let navigationController = UINavigationController(rootViewController: viewConroller)
        navigationController.view.backgroundColor = .systemBackground
        presenter.viewController = viewConroller
        presenter.router = router
        return viewConroller
    }
}
