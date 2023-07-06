//
//  StatisticsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 14.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class StatisticsRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func reset(statisticsKind: StatisticsKind, yesHandler: @escaping Block) {
        let alertController = UIAlertController(title: "attention".localized,
                                                message: statisticsKind.resetText,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "cancel".localized, style: .cancel))
        alertController.addAction(.init(title: "yes".localized, style: .destructive, handler: { _ in
            yesHandler()
        }))
        viewController?.present(alertController, animated: true)
    }
    
    func goToPaywall() {
        let vc = UIHostingController(rootView: PaywallView())
        vc.modalPresentationStyle = .formSheet
        viewController?.present(vc, animated: true)
    }
}
