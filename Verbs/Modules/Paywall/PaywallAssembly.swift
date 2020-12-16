//
//  PaywallAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class PaywallAssembly: AssemblyProtocol {
    
    func viewController() -> some PaywallViewController {
        let presenter = PaywallPresenter(languageService: .init())
        let viewController = PaywallViewController(presenter: presenter,
                                                   purchaseService: .init())
        let router = PaywallRouter(viewController: viewController)
        viewController.router = router
        return viewController
    }
}
