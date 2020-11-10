//
//  SettingsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsAssembly: AssemblyProtocol {
    
    typealias ViewController = SettingsViewController
    
    func viewController() -> ViewController {
        let presenter = SettingsPresenter(languageService: .init(),
                                          mailService: .init(),
                                          userDefaultsService: .init())
        let viewController = SettingsViewController(presenter: presenter)
        let nvc = UINavigationController(rootViewController: viewController)
        let router = SettingsRouter(navigationController: nvc)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
