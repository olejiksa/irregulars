//
//  DetailRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func goToPaywall() {
        let vc = PaywallViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        navigationController?.present(nvc, animated: true)
    }
}
