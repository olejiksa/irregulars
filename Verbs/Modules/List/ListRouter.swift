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
        let presenter = DetailPresenter(audioService: .init(),
                                        languageService: .init(),
                                        verb: verb)
        let vc = DetailViewController(presenter: presenter)
        navigationController?.push(vc, in: splitViewController)
    }
    
    func goToSettings(regularVerbsBlock shouldRegularVerbsBeShownBlock: @escaping (Bool) -> (),
                      derivedFormsBlock shouldDerivedFormsBeShownBlock: @escaping (Bool) -> (),
                      listViewBlock: @escaping (Settings.ListView) -> ()) {
        let assembly = SettingsAssembly(shouldRegularVerbsBeShownBlock: shouldRegularVerbsBeShownBlock,
                                        shouldDerivedFormsBeShownBlock: shouldDerivedFormsBeShownBlock,
                                        listViewBlock: listViewBlock)
        let vc = assembly.viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        navigationController?.present(nvc, animated: true)
    }
}
