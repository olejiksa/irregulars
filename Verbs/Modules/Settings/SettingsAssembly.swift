//
//  SettingsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsAssembly {
    
    private let shouldRegularVerbsBeShownBlock: ((Bool) -> ())
    private let shouldDerivedFormsBeShownBlock: ((Bool) -> ())
    
    init(shouldRegularVerbsBeShownBlock: @escaping ((Bool) -> ()),
         shouldDerivedFormsBeShownBlock: @escaping ((Bool) -> ())) {
        self.shouldRegularVerbsBeShownBlock = shouldRegularVerbsBeShownBlock
        self.shouldDerivedFormsBeShownBlock = shouldDerivedFormsBeShownBlock
    }
    
    func viewController() -> SettingsViewController {
        let presenter = SettingsPresenter(mailService: .init(),
                                          userDefaultsService: .init(),
                                          shouldRegularVerbsBeShownBlock: shouldRegularVerbsBeShownBlock,
                                          shouldDerivedFormsBeShownBlock: shouldDerivedFormsBeShownBlock)
        let viewController =  SettingsViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
