//
//  ListMenu.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListMenu {
    
    private weak var barButtonItem: UIBarButtonItem?
    private let hasTranslation: Bool
    private let favoritesOnly: Bool
    private let printInfoBlock: Block?
    private let updateDerivativesBlock: BoolBlock?
    private let updateRegularsBlock: BoolBlock?
    
    init(barButtonItem: UIBarButtonItem?,
         hasTranslation: Bool,
         favoritesOnly: Bool,
         printInfoBlock: Block?,
         updateDerivativesBlock: BoolBlock? = nil,
         updateRegularsBlock: BoolBlock? = nil) {
        self.barButtonItem = barButtonItem
        self.hasTranslation = hasTranslation
        self.favoritesOnly = favoritesOnly
        self.printInfoBlock = printInfoBlock
        self.updateDerivativesBlock = updateDerivativesBlock
        self.updateRegularsBlock = updateRegularsBlock
    }
    
    func build() {
        let shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        let shouldSimilarBeShown = UserDefaults.shared.bool(for: .shouldSimilarBeShown)
        
        barButtonItem?.menu = .init(children: [
            UIMenu(options: .displayInline, children: [
                UIAction(title: "three_forms".localized,
                         attributes: !hasTranslation ? .hidden : [],
                         state: !shouldTranslationBeShown ? .on : .off,
                         handler: handleViewMenu),
                UIAction(title: .localized(.translation),
                         attributes: !hasTranslation ? .hidden : [],
                         state: shouldTranslationBeShown ? .on : .off,
                         handler: handleViewMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "A-Z",
                         attributes: [],
                         state: !shouldSimilarBeShown ? .on : .off,
                         handler: handleSimilarityMenu),
                UIAction(title: "by_similarity".localized,
                         attributes: [],
                         state: shouldSimilarBeShown ? .on : .off,
                         handler: handleSimilarityMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "regular_verbs".localized,
                         attributes: favoritesOnly ? .hidden : [],
                         state: shouldRegularVerbsBeShown ? .on : .off,
                         handler: handleRegularsMenu),
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "derivatives".localized,
                         attributes: favoritesOnly ? .hidden : [],
                         state: shouldDerivativesBeShown ? .on : .off,
                         handler: handleDerivativesMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "print".localized,
                         image: SystemIcon.printer.image,
                         handler: handlePrint)
            ])
        ].compactMap { $0 })
    }
}

// MARK: - Private

private extension ListMenu {
    
    func handleViewMenu(action: UIAction) {
        let shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
        let state = action.state == .on
        let newState = shouldTranslationBeShown == state
        UserDefaults.shared.set(newState, for: .shouldTranslationBeShown)
        NotificationCenter.default.post(name: .listView,
                                        object: nil,
                                        userInfo: [Notification.Name.listView: newState])
        
        build()
    }
    
    func handleSimilarityMenu(action: UIAction) {
        let shouldSimilarBeShown = UserDefaults.shared.bool(for: .shouldSimilarBeShown)
        let state = action.state == .on
        let newState = shouldSimilarBeShown == state
        UserDefaults.shared.set(newState, for: .shouldSimilarBeShown)
        NotificationCenter.default.post(name: .grouping,
                                        object: nil,
                                        userInfo: [Notification.Name.grouping: newState])
        
        build()
    }
    
    func handleRegularsMenu(action: UIAction) {
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        UserDefaults.shared.set(!shouldRegularVerbsBeShown, for: .regularVerbs)
        updateRegularsBlock?(!shouldRegularVerbsBeShown)
        
        build()
    }
    
    func handleDerivativesMenu(action: UIAction) {
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        UserDefaults.shared.set(!shouldDerivativesBeShown, for: .derivatives)
        updateDerivativesBlock?(!shouldDerivativesBeShown)
        
        build()
    }
    
    func handlePrint(action: UIAction) {
        printInfoBlock?()
    }
}
