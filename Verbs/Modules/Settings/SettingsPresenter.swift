//
//  SettingsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import StoreKit

final class SettingsPresenter: NSObject {
    
    weak var viewController: SettingsViewController?
    
    private let mailService: MailService
    private let userDefaultsService: UserDefaultsService
    private var settings: Settings
    private let shouldRegularVerbsBeShownBlock: ((Bool) -> ())
    private let shouldDerivedFormsBeShownBlock: ((Bool) -> ())
    private var sections = SectionArray()
    
    init(mailService: MailService,
         userDefaultsService: UserDefaultsService,
         shouldRegularVerbsBeShownBlock: @escaping ((Bool) -> ()),
         shouldDerivedFormsBeShownBlock: @escaping ((Bool) -> ())) {
        self.mailService = mailService
        self.userDefaultsService = userDefaultsService
        self.settings = userDefaultsService.load() ?? .init()
        self.shouldRegularVerbsBeShownBlock = shouldRegularVerbsBeShownBlock
        self.shouldDerivedFormsBeShownBlock = shouldDerivedFormsBeShownBlock
        super.init()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsPresenter {
    
    func setupItems() {
        let mailActionBlock: (() -> ()) = { [weak mailService, weak viewController] in
            mailService?.present(in: viewController)
        }
        
        sections.setup([Section(header: "Unlock all features".localized,
                                items: [DisclosureItem(text: "Buy full version".localized,
                                                       isEnabled: true,
                                                       actionBlock: {}),
                                        DisclosureItem(text: "Restore a purchase".localized,
                                                       isEnabled: true,
                                                       actionBlock: {})].filter { _ in !FeatureToggle.isPaid }),
                        Section(header: "General".localized,
                                items: [DisclosureItem(text: "Language".localized,
                                                       isEnabled: true,
                                                       actionBlock: willShowLanguageSettings),
                                        SwitchItem(text: "Regular verbs (-ed)".localized,
                                                   isOn: settings.shouldRegularVerbsBeShown,
                                                   isEnabled: FeatureToggle.isPaid,
                                                   actionBlock: didRegularVerbsOptionChange),
                                        SwitchItem(text: "Derived forms".localized,
                                                   isOn: settings.shouldDerivedFormsBeShown,
                                                   isEnabled: FeatureToggle.isPaid,
                                                   actionBlock: didDerivedFormsOptionChange)]),
                        Section(header: "Links".localized,
                                items: [DisclosureItem(text: "Rate and review".localized,
                                                       isEnabled: false,
                                                       actionBlock: willRate),
                                        DisclosureItem(text: "Contact us".localized,
                                                       isEnabled: mailService.isMailAvailable,
                                                       actionBlock: mailActionBlock)])])
    }
    
    func didRegularVerbsOptionChange(_ value: Bool) {
        settings.shouldRegularVerbsBeShown = value
        userDefaultsService.save(settings)
        shouldRegularVerbsBeShownBlock(value)
    }
    
    func didDerivedFormsOptionChange(_ value: Bool) {
        settings.shouldDerivedFormsBeShown = value
        userDefaultsService.save(settings)
        shouldDerivedFormsBeShownBlock(value)
    }
    
    func willShowLanguageSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func willRate() {
        let scenes = UIApplication.shared.connectedScenes
        
        guard
            let scene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
        
        SKStoreReviewController.requestReview(in: scene)
    }
}

// MARK: - UITableViewDataSource

extension SettingsPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections.header(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections.item(indexPath)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension SettingsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let actionableItem = sections.item(indexPath) as? Actionable
        actionableItem?.actionBlock()
    }
}
