//
//  SettingsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsAssembly {
    
    private let shouldRegularVerbsBeShownBlock: (Bool) -> ()
    private let shouldDerivedFormsBeShownBlock: (Bool) -> ()
    private let listViewBlock: (Settings.ListView) -> ()
    
    init(shouldRegularVerbsBeShownBlock: @escaping (Bool) -> (),
         shouldDerivedFormsBeShownBlock: @escaping (Bool) -> (),
         listViewBlock: @escaping (Settings.ListView) -> ()) {
        self.shouldRegularVerbsBeShownBlock = shouldRegularVerbsBeShownBlock
        self.shouldDerivedFormsBeShownBlock = shouldDerivedFormsBeShownBlock
        self.listViewBlock = listViewBlock
    }
    
    func viewController() -> SettingsViewController {
        let presenter = SettingsPresenter(languageService: .init(),
                                          mailService: .init(),
                                          userDefaultsService: .init(),
                                          shouldRegularVerbsBeShownBlock: shouldRegularVerbsBeShownBlock,
                                          shouldDerivedFormsBeShownBlock: shouldDerivedFormsBeShownBlock,
                                          listViewBlock: listViewBlock)
        let viewController =  SettingsViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
