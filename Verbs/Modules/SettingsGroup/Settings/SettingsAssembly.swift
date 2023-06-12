//
//  SettingsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsAssembly: AssemblyProtocol {
    
    private let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func viewController() -> some SettingsViewController {
        let languageService = LanguageService()
        let mailService = MailService()
        let notificationService = NotificationService(verbsService: .init(),
                                                      calendarService: .init())
        let itemsFactory = SettingsItemsFactory(languageService: languageService,
                                                mailService: mailService)
        let presenter = SettingsPresenter(languageService: languageService,
                                          mailService: mailService,
                                          notificationService: notificationService,
                                          itemsFactory: itemsFactory)
        let viewController = SettingsViewController(presenter: presenter)
        let navigationController = self.navigationController ??
            UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = .systemBackground
        let router = SettingsRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
