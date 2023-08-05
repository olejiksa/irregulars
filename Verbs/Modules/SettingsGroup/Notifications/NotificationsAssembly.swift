//
//  NotificationsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class NotificationsAssembly: AssemblyProtocol {
    
    func viewController() -> some NotificationsViewController {
        let presenter = NotificationsPresenter(notificationService: .init(verbsService: .init(),
                                                                          calendarService: .init()))
        let viewController = NotificationsViewController(presenter: presenter)
        viewController.title = String.localized(.accentColor)
        viewController.hidesBottomBarWhenPushed = true
        let router = NotificationsRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
