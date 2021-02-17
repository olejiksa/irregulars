//
//  NotificationsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class NotificationsAssembly: AssemblyProtocol {
    
    func viewController() -> some NotificationsViewController {
        let presenter = NotificationsPresenter(notificationService: .init(verbsService: .init()))
        let viewConroller = NotificationsViewController(presenter: presenter)
        let router = NotificationsRouter(viewController: viewConroller)
        presenter.viewController = viewConroller
        presenter.router = router
        return viewConroller
    }
}
