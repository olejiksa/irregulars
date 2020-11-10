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
        
        let vc = DetailAssembly(verb: verb, isOpenedByDeeplink: true).viewController()
        var nvc: UINavigationController?
        
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tvc = splitViewController.viewController(for: .compact) as? UITabBarController
            tvc?.selectedIndex = 0
            nvc = tvc?.selectedViewController as? UINavigationController
            guard !checkIfAlreadyOpened(by: host, in: nvc) else { return }
            splitViewController.dismiss(animated: true)
            nvc?.push(vc)
        case .regular:
            nvc = splitViewController.viewControllers.last as? UINavigationController
            guard !checkIfAlreadyOpened(by: host, in: nvc) else { return }
            splitViewController.dismiss(animated: true)
            nvc?.push(vc)
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
}
