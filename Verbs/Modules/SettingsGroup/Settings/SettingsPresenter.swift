//
//  SettingsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: SettingsRouter?
    weak var viewController: SettingsViewController?
    
    private let webURL = URL(string: "https://apps.apple.com/app/id1540487254")
    private let appStoreURL = URL(string: "itms-apps://apps.apple.com/app/id1540487254")
    private let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")
    private let languageService: LanguageService
    private let mailService: MailService
    private let notificationService: NotificationService
    private let itemsFactory: SettingsItemsFactory
    
    init(languageService: LanguageService,
         mailService: MailService,
         notificationService: NotificationService,
         itemsFactory: SettingsItemsFactory) {
        self.languageService = languageService
        self.mailService = mailService
        self.notificationService = notificationService
        self.itemsFactory = itemsFactory
        super.init()
        subscribe()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsPresenter {
    
    var areAllAppsAvailable: Bool {
        guard let value = developerURL.map(UIApplication.shared.canOpenURL) else { return false }
        return value
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: .reload,
                                               object: nil)
    }
    
    func setupItems() {
        dataSource.setup([
            itemsFactory.setupActivationSection(upgradeBlock: willUpgrade,
                                                resetBlock: willReset),
            itemsFactory.setupGeneralSection(languageBlock: willShowSystemAppSettings,
                                             accentColorBlock: willGoToAccentColor,
                                             voiceBlock: willGoToVoice,
                                             notificationsBlock: willGoToNotifications),
            itemsFactory.setupLinksSection(rateBlock: willRate,
                                           privacyBlock: willGoToPrivacyPolicy,
                                           termsBlock: willGoToTermsOfUse,
                                           mailBlock: willGoToMail,
                                           shareBlock: willShare),
            itemsFactory.setupAboutSection(areAllAppsAvailable: areAllAppsAvailable,
                                           acknowledgementsBlock: willGoToAcknowledgements,
                                           allAppsBlock: willOverviewAllApps,
                                           upgradeBlock: willUpgrade)
        ])
    }
    
    func didPlaybackSpeedChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .playbackSpeed)
    }
    
    func willShowSystemAppSettings(_ sender: ItemProtocol) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        router?.open(url)
    }
    
    func willRate(_ sender: ItemProtocol) {
        guard let productURL = appStoreURL else { return }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        router?.open(writeReviewURL)
    }
    
    func willOverviewAllApps(_ sender: ItemProtocol) {
        guard let developerURL = developerURL else { return }
        router?.open(developerURL)
    }
    
    func willGoToMail(_ sender: ItemProtocol) {
        mailService.present()
    }
    
    func willGoToAcknowledgements(_ sender: ItemProtocol) {
        router?.goToAcknowledgements()
    }
    
    func willGoToPrivacyPolicy(_ sender: ItemProtocol) {
        let code = languageService.legal.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
        else { return }
        router?.goToURL(url)
    }
    
    func willGoToTermsOfUse(_ sender: ItemProtocol) {
        let code = languageService.legal.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/terms-\(code).md")
        else { return }
        router?.goToURL(url)
    }
    
    func willGoToAccentColor(_ sender: ItemProtocol) {
        router?.goToAccentColor()
    }
    
    func willGoToVoice(_ sender: ItemProtocol) {
        router?.goToVoice()
    }
    
    func willGoToNotifications(_ sender: ItemProtocol) {
        router?.goToNotifications()
    }
    
    func willShare(_ sender: ItemProtocol) {
        guard let productURL = webURL, let view = viewController?.view else { return }
        router?.share(productURL, in: view)
    }
    
    func willUpgrade(_ sender: ItemProtocol) {
        router?.goToPaywall()
    }
    
    func willReset(_ sender: ItemProtocol) {
        FeatureToggle.isPaid = false
        viewController?.reloadData()
    }
    
    @objc func didPay(_ notification: Notification) {
        DispatchQueue.main.async {
            self.setupItems()
            self.viewController?.reloadData()
            self.updateNotificationsAvailability()
        }
    }
    
    func updateNotificationsAvailability() {
        notificationService.checkAvailability { [weak self] result in
            guard let self = self else { return }
            Locator.areNotificationsAvailable = result
            DispatchQueue.main.async {
                self.setupItems()
                self.viewController?.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let actionableItem = dataSource.item(at: indexPath) as? Actionable,
              let item = actionableItem as? ItemProtocol else { return }
        
        actionableItem.actionBlock?(item)
    }
}
