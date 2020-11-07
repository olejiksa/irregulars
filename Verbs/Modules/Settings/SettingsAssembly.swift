//
//  SettingsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsAssembly {
    
    func viewController() -> SettingsViewController {
        let presenter = SettingsPresenter(languageService: .init(),
                                          mailService: .init(),
                                          userDefaultsService: .init())
        let viewController = SettingsViewController(presenter: presenter)
        _ = UINavigationController(rootViewController: viewController)
        presenter.viewController = viewController
        return viewController
    }
}
