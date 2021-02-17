//
//  NotificationsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NotificationsRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
