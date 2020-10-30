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
    weak var viewController: SettingsViewController?
    
    private let languageService: LanguageService
    private let mailService: MailService
    private let userDefaultsService: UserDefaultsService
    private var settings: Settings
    private let shouldRegularVerbsBeShownBlock: (Bool) -> ()
    private let shouldDerivedFormsBeShownBlock: (Bool) -> ()
    private let listViewBlock: (Settings.ListView) -> ()
    
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
        guard let version = Bundle.main.releaseVersionNumber,
              let name = Bundle.main.productName else { return }
        
        let editionName = FeatureToggle.isPaid ? "\(name) Pro" : "\(name) Basic"
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
        
        dataSource.setup([Section(header: "Activation".localized,
                                  items: [DisclosureItem(text: "Unlock all features".localized,
                                                         isEnabled: true,
                                                         actionBlock: willBuy)].filter { _ in !FeatureToggle.isPaid }),
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
        guard let productURL = URL(string: "https://itunes.apple.com/app/id958625272") else { return }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "action", value: "write-review") ]
        guard let writeReviewURL = components?.url,
              UIApplication.shared.canOpenURL(writeReviewURL)
        else { return }
        UIApplication.shared.open(writeReviewURL)
    }
    
    func willGoToPrivacyPolicy(_ sender: ItemProtocol) {
        var url: URL?
        if languageService.current == .russian {
            url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-ru.md")
        } else {
            url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-en.md")
        }
        guard let urlUnwrapped = url else { return }
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: urlUnwrapped, configuration: configuration)
        viewController?.present(vc, animated: true)
    }
    
    func willShare(_ sender: ItemProtocol) {
        guard let productURL = URL(string: "https://itunes.apple.com/app/id958625272") else { return }
        let activityViewController = UIActivityViewController(activityItems: [productURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func willBuy(_ sender: ItemProtocol) {
        let vc = PaywallViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
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
