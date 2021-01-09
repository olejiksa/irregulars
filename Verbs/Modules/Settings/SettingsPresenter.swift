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
    
    private let productURL = URL(string: "https://apps.apple.com/app/id1540487254")
    private let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")
    private let languageService: LanguageService
    private let mailService: MailService
    private let itemsFactory: SettingsItemsFactory
    
    init(languageService: LanguageService,
         mailService: MailService,
         itemsFactory: SettingsItemsFactory) {
        self.languageService = languageService
        self.mailService = mailService
        self.itemsFactory = itemsFactory
        super.init()
        subscribe()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsPresenter {
    
    var areAllAppsAvailable: Bool {
        guard !FeatureToggle.isDebug,
              let value = developerURL.map(UIApplication.shared.canOpenURL) else { return false }
        return value
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func setupItems() {
        dataSource.setup(
            [itemsFactory.setupActivationSection(upgradeBlock: willUpgrade,
                                                 resetBlock: willReset),
             itemsFactory.setupGeneralSection(languageBlock: willShowLanguageSettings,
                                              accentColorBlock: willGoToAccentColor,
                                              voiceBlock: willGoToVoice),
             itemsFactory.setupPlaybackSpeedSection(playbackSpeedBlock: didPlaybackSpeedChange),
             itemsFactory.setupLinksSection(rateBlock: willRate,
                                            privacyBlock: willGoToPrivacyPolicy,
                                            termsBlock: willGoToTermsOfUse,
                                            mailBlock: willGoToMail,
                                            shareBlock: willShare,
                                            acknowledgementsBlock: willGoToAcknowledgements),
             itemsFactory.setupAboutSection(areAllAppsAvailable: areAllAppsAvailable,
                                            allAppsBlock: willOverviewAllApps,
                                            upgradeBlock: willUpgrade)]
        )
    }
    
    func didListViewChange(_ sender: ItemProtocol) {
        guard let item = sender as? PickableItem else { return }
        let value = item.subtitle == .localized(.translation)
        UserDefaults.shared.set(value, for: .shouldTranslationBeShown)
        NotificationCenter.default.post(name: .list,
                                        object: nil,
                                        userInfo: [Notification.Name.list: value])
        viewController?.reloadData()
    }
    
    func didPlaybackSpeedChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .playbackSpeed)
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
    
    func willOverviewAllApps(_ sender: ItemProtocol) {
        guard let developerURL = developerURL else { return }
        router?.open(developerURL)
    }
    
    func willGoToMail(_ sender: ItemProtocol) {
        mailService.present(in: viewController)
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
    
    func willShare(_ sender: ItemProtocol) {
        guard let productURL = productURL, let view = viewController?.view else { return }
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
        setupItems()
        viewController?.reloadData()
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
