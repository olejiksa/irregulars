//
//  ListRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListRouter {
    
    private weak var navigationController: UINavigationController?
    private weak var splitViewController: UISplitViewController?
    
    init(navigationController: UINavigationController?,
         splitViewController: UISplitViewController?) {
        self.navigationController = navigationController
        self.splitViewController = splitViewController
    }
    
    func goToDetail(with verb: Verb) {
        let vc = DetailViewController(verb: verb)
        navigationController?.push(vc, in: splitViewController)
    }
    
    func goToSettings(with shouldRegularVerbsBeShownBlock: @escaping ((Bool) -> ())) {
        let vc = SettingsViewController()
        vc.shouldRegularVerbsBeShownBlock = shouldRegularVerbsBeShownBlock
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        navigationController?.present(nvc, animated: true)
    }
}
