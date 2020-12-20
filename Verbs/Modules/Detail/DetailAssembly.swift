//
//  DetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailAssembly: AssemblyProtocol {
    
    private let verb: Verb
    private let isOpenedByDeeplink: Bool
    private let navigationController: UINavigationController?
    
    init(verb: Verb, isOpenedByDeeplink: Bool, navigationController: UINavigationController?) {
        self.verb = verb
        self.isOpenedByDeeplink = isOpenedByDeeplink
        self.navigationController = navigationController
    }
    
    func viewController() -> some DetailViewController {
        let audioService = AudioService(voiceService: .init())
        let presenter = DetailPresenter(audioService: audioService,
                                        languageService: .init(),
                                        sentencesService: .init(),
                                        verb: verb)
        let router = DetailRouter(navigationController: navigationController)
        presenter.router = router
        let viewConroller = DetailViewController(presenter: presenter,
                                                 verb: verb,
                                                 isOpenedByDeeplink: isOpenedByDeeplink)
        presenter.viewController = viewConroller
        return viewConroller
    }
}
