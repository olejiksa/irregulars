//
//  DeeplinkService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DeeplinkService {
    
    private let verbsService = VerbsService()
    
    func handle(_ host: String, in splitViewController: UISplitViewController) {
        guard let verb = verbsService.items.first(where: { host == $0.infinitive.value }) else { return }
        
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 0
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            handle(host: host,
                   verb: verb,
                   navigationController: navigationController,
                   splitViewController: splitViewController)
        case .regular:
            let navigationController = splitViewController.viewControllers.last as? UINavigationController
            guard !checkIfAlreadyOpened(by: host, in: navigationController) else { return }
            handle(host: host,
                   verb: verb,
                   navigationController: navigationController,
                   splitViewController: splitViewController)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Private

private extension DeeplinkService {
    
    func checkIfAlreadyOpened(by title: String, in navigationController: UINavigationController?) -> Bool {
        navigationController?.topViewController?.navigationItem.title == title
    }
    
    func handle(host: String,
                verb: Verb,
                navigationController: UINavigationController?,
                splitViewController: UISplitViewController?) {
        guard !checkIfAlreadyOpened(by: host, in: navigationController) else { return }
        splitViewController?.dismiss(animated: true)
        let vc = DetailAssembly(verb: verb,
                                isOpenedByDeeplink: true,
                                navigationController: navigationController).viewController()
        navigationController?.push(vc, in: splitViewController)
    }
}
