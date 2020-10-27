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
    
    private let languageService: LanguageService
    private let mailService: MailService
    private let userDefaultsService: UserDefaultsService
    private var settings: Settings
    private let shouldRegularVerbsBeShownBlock: (Bool) -> ()
    private let shouldDerivedFormsBeShownBlock: (Bool) -> ()
    private let listViewBlock: (Settings.ListView) -> ()
    private var sections = SectionArray()
    
    init(languageService: LanguageService,
         mailService: MailService,
         userDefaultsService: UserDefaultsService,
         shouldRegularVerbsBeShownBlock: @escaping (Bool) -> (),
         shouldDerivedFormsBeShownBlock: @escaping (Bool) -> (),
         listViewBlock: @escaping (Settings.ListView) -> ()) {
        self.languageService = languageService
        self.mailService = mailService
        self.userDefaultsService = userDefaultsService
        self.settings = userDefaultsService.load() ?? .init()
        self.shouldRegularVerbsBeShownBlock = shouldRegularVerbsBeShownBlock
        self.shouldDerivedFormsBeShownBlock = shouldDerivedFormsBeShownBlock
        self.listViewBlock = listViewBlock
        super.init()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsPresenter {
    
    func setupItems() {
        guard let version = Bundle.main.releaseVersionNumber else { return }
        
        let mailActionBlock: ((ItemProtocol) -> ()) = { [weak self] _ in
            guard let self = self else { return }
            self.mailService.present(in: self.viewController)
        }
        
        let options = Settings.ListView.allCases.map(\.description)
        let listShowsItem = languageService.hasTranslation ?
            RightDetailItem(title: "List".localized,
                            subtitle: settings.listView.description,
                            actionBlock: didListViewChange,
                            subitems: options,
                            isEnabled: FeatureToggle.isPaid) : nil
        
        sections.setup([Section(header: "Unlock all features".localized,
                                items: [DisclosureItem(text: "Buy full version".localized,
                                                       isEnabled: true,
                                                       actionBlock: { _ in }),
                                        DisclosureItem(text: "Restore a purchase".localized,
                                                       isEnabled: true,
                                                       actionBlock: { _ in })].filter { _ in !FeatureToggle.isPaid }),
                        Section(header: "General".localized,
                                items: [DisclosureItem(text: "Language".localized,
                                                       isEnabled: true,
                                                       actionBlock: willShowLanguageSettings),
                                        SwitchItem(text: "Regular verbs (-ed)".localized,
                                                   isOn: settings.shouldRegularVerbsBeShown,
                                                   isEnabled: FeatureToggle.isPaid,
                                                   actionBlock: didRegularVerbsOptionChange),
                                        SwitchItem(text: "Derivatives".localized,
                                                   isOn: settings.shouldDerivedFormsBeShown,
                                                   isEnabled: FeatureToggle.isPaid,
                                                   actionBlock: didDerivedFormsOptionChange)] +
                                        [listShowsItem].compactMap { $0 }),
                        Section(header: "Links".localized,
                                items: [DisclosureItem(text: "Rate and review".localized,
                                                       isEnabled: false,
                                                       actionBlock: willRate),
                                        DisclosureItem(text: "Contact us".localized,
                                                       isEnabled: mailService.isMailAvailable,
                                                       actionBlock: mailActionBlock)]),
                        Section(header: "About".localized,
                                items: [RightDetailItem(title: "Developer".localized,
                                                        subtitle: "Oleg Samoylov".localized),
                                        RightDetailItem(title: "Version".localized,
                                                        subtitle: version)])])
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
    
    func didListViewChange(_ sender: ItemProtocol) {
        guard let item = sender as? RightDetailItem else { return }
        settings.listView = Settings.ListView(description: item.subtitle)
        userDefaultsService.save(settings)
        listViewBlock(settings.listView)
        viewController?.reloadData()
    }
    
    func willShowLanguageSettings(_ sender: ItemProtocol) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func willRate(_ sender: ItemProtocol) {
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
        
        if let cell = tableView.cellForRow(at: indexPath) as? RightDetailCell,
           let item = sections.item(indexPath) as? RightDetailItem,
           item.actionBlock != nil,
           !cell.isFirstResponder {
            _ = cell.becomeFirstResponder()
        } else if let actionableItem = sections.item(indexPath) as? Actionable,
                  let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}

private extension Bundle {
    
    var releaseVersionNumber: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
}
