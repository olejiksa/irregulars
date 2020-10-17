//
//  DetailAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailAssembly {
    
    func viewController(verb: Verb, isOpenedByDeeplink: Bool) -> DetailViewController {
        let presenter = DetailPresenter(audioService: .init(),
                                        languageService: .init(),
                                        verb: verb)
        return .init(presenter: presenter, isOpenedByDeeplink: isOpenedByDeeplink)
    }
}

