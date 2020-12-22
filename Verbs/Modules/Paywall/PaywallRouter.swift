//
//  PaywallRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PaywallRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(error: Error) {
        let alertController = UIAlertController(title: "error".localized,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        viewController?.present(alertController, animated: true)
    }
}
