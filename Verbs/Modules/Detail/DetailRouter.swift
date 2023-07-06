//
//  DetailRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class DetailRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func goToPaywall() {
        let vc = UIHostingController(rootView: PaywallView())
        vc.modalPresentationStyle = .formSheet
        navigationController?.present(vc, animated: true)
    }
}
