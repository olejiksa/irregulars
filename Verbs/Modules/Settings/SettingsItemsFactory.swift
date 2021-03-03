//
//  SettingsItemsFactory.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class SettingsItemsFactory {
    
    private let languageService: LanguageService
    private let mailService: MailService
    
    init(languageService: LanguageService,
         mailService: MailService) {
        self.languageService = languageService
        self.mailService = mailService
    }
    
    func setupActivationSection(upgradeBlock: @escaping ItemBlock,
                                resetBlock: @escaping ItemBlock) -> Section {
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "upgrade_to_pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let downgradeText = "downgrade_to".localized
        let resetItem = FeatureToggle.isPaid && FeatureToggle.isDebug ? ActionItem(text: downgradeText,
                                                                                   style: .standard,
                                                                                   actionBlock: resetBlock) : nil
        let header = FeatureToggle.isPaid ? "deactivation".localized : "activation".localized
        return .init(header: header, items: [upgradeItem, resetItem].compactMap { $0 })
    }
    
    func setupGeneralSection(languageBlock: @escaping ItemBlock,
                             accentColorBlock: @escaping ItemBlock,
                             voiceBlock: @escaping ItemBlock,
                             notificationsBlock: @escaping ItemBlock) -> Section {
        let accentColor = AccentColor.current.rawValue.localized
        let voiceID = UserDefaults.shared.string(for: .voice) ?? ""
        let voiceName = VoiceService().voiceName(identifier: voiceID)
        
        let notificationsSubtitle: String
        switch (Locator.areNotificationsAvailable,
                UserDefaults.shared.bool(for: .notifications)) {
        case (true, true):
            notificationsSubtitle = "enabled".localized
        case (true, false):
            notificationsSubtitle = "disabled".localized
        case (false, _):
            notificationsSubtitle = "not_allowed".localized
        }
        
        #if targetEnvironment(macCatalyst)
        let items: [ItemProtocol] = [RightDetailItem(title: "language".localized,
                                                     subtitle: languageService.current.description,
                                                     actionBlock: languageBlock),
                                     RightDetailItem(title: "voice".localized,
                                                     subtitle: voiceName,
                                                     actionBlock: voiceBlock,
                                                     accessibilityIdentifier: .voiceCell),
                                     RightDetailItem(title: .localized(.notifications),
                                                     subtitle: notificationsSubtitle,
                                                     actionBlock: notificationsBlock)].compactMap { $0 }
        #else
        let items: [ItemProtocol] = [RightDetailItem(title: "language".localized,
                                                     subtitle: languageService.current.description,
                                                     actionBlock: languageBlock),
                                     RightDetailItem(title: "accent_color".localized,
                                                     subtitle: accentColor,
                                                     actionBlock: accentColorBlock,
                                                     accessibilityIdentifier: .accentColorCell),
                                     RightDetailItem(title: "voice".localized,
                                                     subtitle: voiceName,
                                                     actionBlock: voiceBlock,
                                                     accessibilityIdentifier: .voiceCell),
                                     RightDetailItem(title: .localized(.notifications),
                                                     subtitle: notificationsSubtitle,
                                                     actionBlock: notificationsBlock,
                                                     accessibilityIdentifier: .notificationsCell)].compactMap { $0 }
        #endif
        
        return .init(header: "general".localized, items: items)
    }
    
    func setupLinksSection(rateBlock: @escaping ItemBlock,
                           privacyBlock: @escaping ItemBlock,
                           termsBlock: @escaping ItemBlock,
                           mailBlock: @escaping ItemBlock,
                           shareBlock: @escaping ItemBlock) -> Section {
        .init(header: .localized(.links),
              items: [ActionItem(text: .localized(.rateAndReview),
                                 actionBlock: rateBlock),
                      ActionItem(text: .localized(.shareApp),
                                 actionBlock: shareBlock),
                      DisclosureItem(text: .localized(.privacyPolicy),
                                     actionBlock: privacyBlock),
                      DisclosureItem(text: .localized(.terms),
                                     actionBlock: termsBlock),
                      DisclosureItem(text: .localized(.contactUs),
                                     isEnabled: mailService.isMailAvailable,
                                     actionBlock: mailBlock)])
    }
    
    func setupAboutSection(areAllAppsAvailable: Bool,
                           acknowledgementsBlock: @escaping ItemBlock,
                           allAppsBlock: @escaping ItemBlock,
                           upgradeBlock: @escaping ItemBlock) -> Section {
        let version = Bundle.main.releaseVersionNumber ?? ""
        let name = Bundle.main.productName ?? ""
        let fullEditionName = "\(name) \(FeatureToggle.editionName)"
        
        return .init(header: .localized(.about),
                     items: [RightDetailItem(title: .localized(.developer),
                                             subtitle: .localized(.olegSamoylov),
                                             actionBlock: allAppsBlock,
                                             hasDisclosureIndicator: true,
                                             isEnabled: areAllAppsAvailable),
                             RightDetailItem(title: .localized(.edition),
                                             subtitle: fullEditionName,
                                             actionBlock: upgradeBlock,
                                             hasDisclosureIndicator: true),
                             RightDetailItem(title: .localized(.version),
                                             subtitle: version),
                             DisclosureItem(text: .localized(.acknowledgements),
                                            actionBlock: acknowledgementsBlock)])
    }
}
