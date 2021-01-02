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
    private let paywallBlock: Block?
    private let updateDerivativesBlock: BoolBlock?
    private let updateRegularsBlock: BoolBlock?
    
    init(barButtonItem: UIBarButtonItem?,
         paywallBlock: Block?,
         updateDerivativesBlock: BoolBlock?,
         updateRegularsBlock: BoolBlock?) {
        self.barButtonItem = barButtonItem
        self.paywallBlock = paywallBlock
        self.updateDerivativesBlock = updateDerivativesBlock
        self.updateRegularsBlock = updateRegularsBlock
    }
    
    func build() {
        let shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        
        let viewMenu = LanguageService().hasTranslation ?
            UIMenu(options: .displayInline, children: [
                UIAction(title: "three_forms".localized,
                         state: !shouldTranslationBeShown ? .on : .off,
                         handler: handleViewMenu),
                UIAction(title: "translation".localized,
                         state: shouldTranslationBeShown ? .on : .off,
                         handler: handleViewMenu)
            ]) : nil
        
//        let printMenu = UIMenu(options: .displayInline, children: [
//            UIAction(title: "print".localized,
//                     image: SystemIcon.printer.image,
//                     handler: handlePrint)
//        ])
        
        barButtonItem?.menu = .init(children: [
            viewMenu,
            UIMenu(options: .displayInline, children: [
                UIAction(title: "regular_verbs".localized,
                         state: shouldRegularVerbsBeShown ? .on : .off,
                         handler: handleRegularsMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "derivatives".localized,
                         state: shouldDerivativesBeShown ? .on : .off,
                         handler: handleDerivativesMenu)
            ]),
//            printMenu
        ].compactMap { $0 })
    }
}

// MARK: - Private

private extension ListMenu {
    
    func handleViewMenu(action: UIAction) {
        let isPaid = FeatureToggle.isPaid
        
        if isPaid {
            let shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
            let state = action.state == .on
            let newState = shouldTranslationBeShown == state
            UserDefaults.shared.set(newState, for: .shouldTranslationBeShown)
            NotificationCenter.default.post(name: .list,
                                            object: nil,
                                            userInfo: [Notification.Name.list: newState])
        } else if action.state == .off {
            paywallBlock?()
        } else {
            return
        }
        
        build()
    }
    
    func handleRegularsMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            paywallBlock?()
            return
        }
        
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        UserDefaults.shared.set(!shouldRegularVerbsBeShown, for: .regularVerbs)
        updateRegularsBlock?(!shouldRegularVerbsBeShown)
        
        build()
    }
    
    func handleDerivativesMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            paywallBlock?()
            return
        }
        
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        UserDefaults.shared.set(!shouldDerivativesBeShown, for: .derivatives)
        updateDerivativesBlock?(!shouldDerivativesBeShown)
        
        build()
    }
    
    func handlePrint(action: UIAction) {
        
    }
}
