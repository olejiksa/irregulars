//
//  VoiceRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 22.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class VoiceRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func goToPaywall() {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
}
