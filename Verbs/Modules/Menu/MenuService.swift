//
//  MenuService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import SafariServices
import UIKit
import SwiftUI

final class MenuService {
    
    private let webURL = URL(string: "https://apps.apple.com/app/id1540487254")
    private let appStoreURL = URL(string: "itms-apps://apps.apple.com/app/id1540487254")
    private let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")

    private let languageService = LanguageService()
    private let mailService = MailService()
    
    private var viewController: SplitViewController? {
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as? SceneDelegate
        return sd?.window?.rootViewController as? SplitViewController
    }
    
    func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == UIMenuSystem.main else { return }
        
        let privacyPolicyCommand = UIAction(title: .localized(.privacyPolicyCapitalized), handler: goToPrivacyPolicy)
        let termsOfUseCommand = UIAction(title: String.localized(.termsOfUseCapitalized), handler: goToTermsOfUse)
        let contactUsCommand = UIAction(title: .localized(.contactUsCapitalized), handler: goToMail)
        let helpSubmenu = UIMenu(options: .displayInline, children: [privacyPolicyCommand,
                                                                     termsOfUseCommand,
                                                                     contactUsCommand])
        builder.insertChild(helpSubmenu, atEndOfMenu: .help)
        
        let allOurAppsCommand = UIAction(title: .localized(.allOurAppsCapitalized), handler: goToAllApps)
        let acknowledgementsCommand = UIAction(title: .localized(.acknowledgementsCapitalized),
                                               handler: goToAcknowledgements)
        let secondHelpSubmenu = UIMenu(options: .displayInline, children: [allOurAppsCommand,
                                                                           acknowledgementsCommand])
        builder.insertChild(secondHelpSubmenu, atEndOfMenu: .help)
        
        let upgradeToProCommand = UIAction(title: .localized(.upgradeToProCapitalized), handler: upgradeToPro)
        let downgradeToLiteCommand = FeatureToggle.isDebug ?
            UIAction(title: "downgrade_to".localized, handler: downgrade)
            : nil
        
        let licenseSubmenuID = UIMenu.Identifier(rawValue: "licenseSubmenu")
        let licenseSubmenu = UIMenu(identifier: licenseSubmenuID,
                                    options: .displayInline,
                                    children: FeatureToggle.isPaid
                                        ? [downgradeToLiteCommand].compactMap { $0 }
                                        : [upgradeToProCommand])
        builder.insertSibling(licenseSubmenu, afterMenu: .about)
        
        let voiceCommand = UIAction(title: .localized(.voice), handler: goToVoice)
        let notificationsCommand = UIAction(title: .localized(.notifications), handler: goToNotifications)
        let settingsSubmenu = UIMenu(options: .displayInline, children: [voiceCommand,
                                                                         notificationsCommand])
        builder.insertSibling(settingsSubmenu, beforeMenu: licenseSubmenuID)
        
        let rateAndReviewCommand = UIAction(title: .localized(.rateAndReviewCapitalized), handler: rateAndReview)
        let shareAppCommand = UIAction(title: .localized(.shareAppCapitalized), handler: shareApp)
        let socialSubmenu = UIMenu(options: .displayInline, children: [rateAndReviewCommand, shareAppCommand])
        builder.insertSibling(socialSubmenu, afterMenu: licenseSubmenuID)
    }
    
    func canPerformAction(_ action: Selector, with sender: Any?) -> Bool {
        if [#selector(goToPrivacyPolicy),
            #selector(goToTermsOfUse),
            #selector(rateAndReview),
            #selector(shareApp)].contains(action) {
            return true
        } else if action == #selector(goToMail) {
            return mailService.isMailAvailable
        } else if action == #selector(goToAllApps) {
            return areAllAppsAvailable
        }
        
        return false
    }
}

// MARK: - Private

private extension MenuService {
    
    var areAllAppsAvailable: Bool {
        guard !FeatureToggle.isDebug,
              let value = developerURL.map(UIApplication.shared.canOpenURL) else { return false }
        return value
    }
    
    @objc func goToPrivacyPolicy(_ action: UIAction) {
        let code = languageService.legal.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
        else { return }
        goToURL(url)
    }
    
    @objc func goToTermsOfUse(_ action: UIAction) {
        let code = languageService.legal.rawValue
        guard let url = URL(string: "https://github.com/olejiksa/legal/blob/master/terms-\(code).md")
        else { return }
        goToURL(url)
    }
    
    @objc func goToMail(_ action: UIAction) {
        mailService.present(in: viewController)
    }
    
    @objc func upgradeToPro(_ action: UIAction) {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
    
    @objc func goToAcknowledgements(_ action: UIAction) {
        guard let top = viewController?.secondaryViewController?.topViewController,
              !(top is UIHostingController<AcknowledgementsView>) else { return }
        
        let vc = AcknowledgementsAssembly().viewController
        viewController?.navigationController?.view?.backgroundColor = .systemBackground
        viewController?.secondaryViewController?.push(vc)
    }
    
    @objc func rateAndReview(_ action: UIAction) {
        guard let productURL = appStoreURL else { return }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        open(writeReviewURL)
    }
    
    @objc func shareApp(_ action: UIAction) {
        guard let productURL = webURL, let view = viewController?.view else { return }
        share(productURL, in: view)
    }
    
    @objc func goToVoice(_ action: UIAction) {
        guard let top = viewController?.secondaryViewController?.topViewController,
              !(top is VoiceViewController) else { return }
        
        let vc = VoiceAssembly().viewController()
        viewController?.secondaryViewController?.push(vc)
    }
    
    @objc func goToNotifications(_ action: UIAction) {
        guard let top = viewController?.secondaryViewController?.topViewController,
              !(top is NotificationsViewController) else { return }
        
        let vc = NotificationsAssembly().viewController()
        viewController?.secondaryViewController?.push(vc)
    }
    
    @objc func goToAllApps(_ action: UIAction) {
        guard let developerURL = developerURL else { return }
        open(developerURL)
    }
    
    @objc func downgrade(_ action: UIAction) {
        FeatureToggle.isPaid = false
        UIMenuSystem.main.setNeedsRebuild()
    }
    
    func goToURL(_ url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: configuration)
        vc.preferredControlTintColor = AccentColor.current.color
        vc.modalPresentationStyle = .pageSheet
        viewController?.present(vc, animated: true)
    }
    
    func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func share(_ url: URL, in view: UIView) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        viewController?.present(activityViewController, animated: true)
    }
}
