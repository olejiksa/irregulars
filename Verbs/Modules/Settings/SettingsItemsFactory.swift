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
                             notificationsBlock: @escaping BoolBlock,
                             settingsBlock: @escaping ItemBlock) -> Section {
        let accentColor = AccentColor.current.rawValue.localized
        let voiceID = UserDefaults.shared.string(for: .voice) ?? ""
        let voiceName = VoiceService().voiceName(identifier: voiceID)
        
        let notificationsItem: ItemProtocol = Locator.areNotificationsAvailable ?
            SwitchItem(text: "notifications".localized,
                       isOn: UserDefaults.shared.bool(for: .notifications),
                       actionBlock: notificationsBlock) :
            RightDetailItem(title: "notifications".localized,
                            subtitle: "not_allowed".localized,
                            actionBlock: settingsBlock)
        
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
                                                     accessibilityIdentifier: .voiceCell)].compactMap { $0 }
        
        return .init(header: "general".localized, items: items + [notificationsItem])
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
