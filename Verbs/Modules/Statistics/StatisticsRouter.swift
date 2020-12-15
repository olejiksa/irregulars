//
//  StatisticsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 14.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func reset(yesHandler: @escaping Block) {
        let alertController = UIAlertController(title: "Attention".localized,
                                                message: "Are you sure that you want to reset statistics?".localized,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "Cancel".localized, style: .cancel))
        alertController.addAction(.init(title: "Yes".localized, style: .destructive, handler: { _ in
            yesHandler()
        }))
        viewController?.present(alertController, animated: true)
    }
    
    func goToPaywall() {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
}
