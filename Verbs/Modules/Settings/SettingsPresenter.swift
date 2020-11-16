//
//  SettingsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

final class SettingsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: SettingsRouter?
    weak var viewController: SettingsViewController?
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1540487254")
    private let languageService: LanguageService
    private let mailService: MailService
    private let userDefaultsService: UserDefaultsService
    private var settings: Settings
    
    init(languageService: LanguageService,
         mailService: MailService,
         userDefaultsService: UserDefaultsService) {
        self.languageService = languageService
        self.mailService = mailService
        self.userDefaultsService = userDefaultsService
        self.settings = userDefaultsService.load() ?? .init()
        super.init()
        subscribe()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.paid,
                                               object: nil)
    }
    
    func setupItems() {
        guard let version = Bundle.main.releaseVersionNumber,
              let name = Bundle.main.productName else { return }
        
        let editionName = FeatureToggle.isPaid ? "\(name) Pro" : "\(name) Lite"
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
        
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "Upgrade to Pro".localized,
                                                             style: .standard,
                                                             actionBlock: willBuy) : nil
        let resetItem = FeatureToggle.isPaid && FeatureToggle.isDebug ? ActionItem(text: "Downgrade".localized,
                                                                                   style: .destructive,
                                                                                   actionBlock: willReset) : nil
        let header = FeatureToggle.isPaid ? "Deactivation".localized : "Activation".localized

        dataSource.setup([Section(header: header,
                                  items: [upgradeItem, resetItem].compactMap { $0 }),
                          Section(header: "General".localized,
                                  items: [RightDetailItem(title: "Language".localized,
                                                          subtitle: languageService.current.description,
                                                          actionBlock: willShowLanguageSettings,
                                                          hasDisclosureItem: true),
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
                                                         isEnabled: true,
                                                         actionBlock: willRate),
                                          DisclosureItem(text: "Privacy policy".localized,
                                                         isEnabled: true,
                                                         actionBlock: willGoToPrivacyPolicy),
                                          DisclosureItem(text: "Contact us".localized,
                                                         isEnabled: mailService.isMailAvailable,
                                                         actionBlock: mailActionBlock),
                                          DisclosureItem(text: "Share the app".localized,
                                                         isEnabled: true,
                                                         actionBlock: willShare)]),
                          Section(header: "About".localized,
                                  items: [RightDetailItem(title: "Developer".localized,
                                                          subtitle: "Oleg Samoylov".localized),
                                          RightDetailItem(title: "Edition".localized,
                                                          subtitle: editionName,
                                                          actionBlock: willBuy,
                                                          hasDisclosureItem: false),
                                          RightDetailItem(title: "Version".localized,
                                                          subtitle: version),])])
    }
    
    func didRegularVerbsOptionChange(_ value: Bool) {
        settings.shouldRegularVerbsBeShown = value
        userDefaultsService.save(settings)
        NotificationCenter.default.post(name: .regulars,
                                        object: nil,
                                        userInfo: [Notification.Name.regulars: value])
    }
    
    func didDerivedFormsOptionChange(_ value: Bool) {
        settings.shouldDerivedFormsBeShown = value
        userDefaultsService.save(settings)
        NotificationCenter.default.post(name: .derivatives,
                                        object: nil,
                                        userInfo: [Notification.Name.derivatives: value])
    }
    
    func didListViewChange(_ sender: ItemProtocol) {
        guard let item = sender as? RightDetailItem else { return }
        settings.listView = Settings.ListView(description: item.subtitle)
        userDefaultsService.save(settings)
        NotificationCenter.default.post(name: .list,
                                        object: nil,
                                        userInfo: [Notification.Name.list: settings.listView])
        viewController?.reloadData()
    }
    
    func willShowLanguageSettings(_ sender: ItemProtocol) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        router?.open(url)
    }
    
    func willRate(_ sender: ItemProtocol) {
        guard let productURL = productURL else { return }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        router?.open(writeReviewURL)
    }
    
    func willGoToPrivacyPolicy(_ sender: ItemProtocol) {
        let code = languageService.current.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
        else { return }
        router?.goToURL(url)
    }
    
    func willShare(_ sender: ItemProtocol) {
        guard let productURL = productURL, let view = viewController?.view else { return }
        router?.share(productURL, in: view)
    }
    
    func willBuy(_ sender: ItemProtocol) {
        router?.goToPaywall()
    }
    
    func willReset(_ sender: ItemProtocol) {
        FeatureToggle.isPaid = false
        userDefaultsService.save(false, by: .isPaid)
        NotificationCenter.default.post(name: .paid, object: nil)
    }
    
    @objc func didPay(_ notification: Notification) {
        setupItems()
        viewController?.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SettingsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? RightDetailCell,
           let item = dataSource.sectionArray.item(indexPath) as? RightDetailItem,
           item.actionBlock != nil,
           !cell.isFirstResponder {
            if item.title == "List".localized {
                _ = cell.becomeFirstResponder()
            } else {
                item.actionBlock?(item)
            }
        } else if let actionableItem = dataSource.sectionArray.item(indexPath) as? Actionable,
                  let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}
