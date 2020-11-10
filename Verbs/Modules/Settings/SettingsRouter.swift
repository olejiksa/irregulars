//
//  SettingsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SafariServices
import UIKit

final class SettingsRouter {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func goToURL(_ url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: configuration)
        vc.modalPresentationStyle = .pageSheet
        navigationController?.present(vc, animated: true)
    }
    
    func goToPaywall() {
        let vc = PaywallViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        navigationController?.present(nvc, animated: true)
    }
}
