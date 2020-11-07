//
//  DetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailAssembly: AssemblyProtocol {
    
    typealias ViewController = DetailViewController
    
    private let verb: Verb
    private let isOpenedByDeeplink: Bool
    
    init(verb: Verb, isOpenedByDeeplink: Bool) {
        self.verb = verb
        self.isOpenedByDeeplink = isOpenedByDeeplink
    }
    
    func viewController() -> ViewController {
        let presenter = DetailPresenter(audioService: .init(),
                                        languageService: .init(),
                                        verb: verb)
        let viewConroller = DetailViewController(presenter: presenter, isOpenedByDeeplink: isOpenedByDeeplink)
        presenter.viewController = viewConroller
        return viewConroller
    }
}
