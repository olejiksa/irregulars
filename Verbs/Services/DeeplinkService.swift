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
        guard let verb = verbsService.items.first(where: { host == $0.infinitive }) else { return }
        
        let vc = DetailViewController(verb: verb)
        let nvc: UINavigationController?
        
        nvc = !splitViewController.isCollapsed
            ? splitViewController.viewControllers.last as? UINavigationController
            : splitViewController.viewControllers.first as? UINavigationController
        
        guard !checkIfAlreadyOpened(by: host, in: nvc) else { return }
        nvc?.push(vc)
    }
}

private extension DeeplinkService {
    
    func checkIfAlreadyOpened(by title: String, in navigationController: UINavigationController?) -> Bool {
        navigationController?.topViewController?.navigationItem.title == title
    }
}
