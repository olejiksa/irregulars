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
    
    init(languageService: LanguageService,
         mailService: MailService) {
        self.languageService = languageService
        self.mailService = mailService
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

        dataSource.setup([setupActivationSection(),
                          Section(header: "General".localized,
                                  items: [RightDetailItem(title: "Language".localized,
                                                          subtitle: languageService.current.description,
                                                          actionBlock: willShowLanguageSettings),
//                                          RightDetailItem(title: "Accent color".localized,
//                                                          subtitle: "Blue".localized,
//                                                          actionBlock: nil,
//                                                          hasDisclosureItem: true,
//                                                          isEnabled: false)
                                  ]),
                          Section(header: "List".localized,
                                  items: [SwitchItem(text: "Regular verbs (-ed)".localized,
                                                     isOn: UserDefaults.standard.bool(for: .shouldRegularVerbsBeShown),
                                                     isEnabled: FeatureToggle.isPaid,
                                                     actionBlock: didRegularVerbsOptionChange),
                                          SwitchItem(text: "Derivatives".localized,
                                                     isOn: UserDefaults.standard.bool(for: .shouldDerivedFormsBeShown),
                                                     isEnabled: FeatureToggle.isPaid,
                                                     actionBlock: didDerivedFormsOptionChange)] +
                                          [setupPickableItem()].compactMap { $0 }),
                          Section(header: "Links".localized,
                                  items: [DisclosureItem(text: "Rate and review".localized,
                                                         actionBlock: willRate),
                                          DisclosureItem(text: "Privacy policy".localized,
                                                         actionBlock: willGoToPrivacyPolicy),
//                                          DisclosureItem(text: "Terms of use".localized,
//                                                         actionBlock: willGoToTermsOfUse),
                                          DisclosureItem(text: "Contact us".localized,
                                                         isEnabled: mailService.isMailAvailable,
                                                         actionBlock: willGoToMail),
                                          DisclosureItem(text: "Share the app".localized,
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
    
    func setupActivationSection() -> Section {
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "Upgrade to Pro".localized,
                                                             style: .standard,
                                                             actionBlock: willBuy) : nil
        let resetItem = FeatureToggle.isPaid && FeatureToggle.isDebug ? ActionItem(text: "Downgrade".localized,
                                                                                   style: .destructive,
                                                                                   actionBlock: willReset) : nil
        let header = FeatureToggle.isPaid ? "Deactivation".localized : "Activation".localized
        return Section(header: header, items: [upgradeItem, resetItem].compactMap { $0 })
    }
    
    func setupPickableItem() -> PickableItem? {
        let options = ["Verb forms".localized, "Translation".localized]
        let currentOption = !UserDefaults.standard.bool(for: .shouldTranslationBeShown)
            ? options.first
            : options.last
        return languageService.hasTranslation ? .init(title: "View".localized,
                                                      subtitle: currentOption ?? "",
                                                      actionBlock: didListViewChange,
                                                      options: options,
                                                      isEnabled: FeatureToggle.isPaid) : nil
    }
    
    func didRegularVerbsOptionChange(_ value: Bool) {
        UserDefaults.standard.set(value, for: .shouldRegularVerbsBeShown)
        NotificationCenter.default.post(name: .regulars,
                                        object: nil,
                                        userInfo: [Notification.Name.regulars: value])
    }
    
    func didDerivedFormsOptionChange(_ value: Bool) {
        UserDefaults.standard.set(value, for: .shouldDerivedFormsBeShown)
        NotificationCenter.default.post(name: .derivatives,
                                        object: nil,
                                        userInfo: [Notification.Name.derivatives: value])
    }
    
    func didListViewChange(_ sender: ItemProtocol) {
        guard let item = sender as? PickableItem else { return }
        let value = item.subtitle == "Translation".localized
        UserDefaults.standard.set(value, for: .shouldTranslationBeShown)
        NotificationCenter.default.post(name: .list,
                                        object: nil,
                                        userInfo: [Notification.Name.list: value])
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
    
    func willGoToMail(_ sender: ItemProtocol) {
        mailService.present(in: viewController)
    }
    
    func willGoToPrivacyPolicy(_ sender: ItemProtocol) {
        let code = languageService.current.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
        else { return }
        router?.goToURL(url)
    }
    
    func willGoToTermsOfUse(_ sender: ItemProtocol) {
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
        
        let item = dataSource.item(at: indexPath)
        
        if item is PickableItem,
           let cell = tableView.cellForRow(at: indexPath),
           !cell.isFirstResponder {
            cell.becomeFirstResponder()
        } else if let actionableItem = dataSource.item(at: indexPath) as? Actionable,
                  let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}
