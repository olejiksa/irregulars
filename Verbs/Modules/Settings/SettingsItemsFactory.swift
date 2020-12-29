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
        let name = Bundle.main.productName ?? ""
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "upgrade_to_pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let downgradeText = "downgrade_to".localized(with: [name])
        let resetItem = FeatureToggle.isPaid && FeatureToggle.isDebug ? ActionItem(text: downgradeText,
                                                                                   style: .standard,
                                                                                   actionBlock: resetBlock) : nil
        let header = FeatureToggle.isPaid ? "deactivation".localized : "activation".localized
        return .init(header: header, items: [upgradeItem, resetItem].compactMap { $0 })
    }
    
    func setupGeneralSection(languageBlock: @escaping ItemBlock,
                             accentColorBlock: @escaping ItemBlock,
                             voiceBlock: @escaping ItemBlock) -> Section {
        let accentColor = AccentColor.current.rawValue.localized
        let voiceID = UserDefaults.shared.string(for: .voice) ?? ""
        let voiceName = VoiceService().voiceName(identifier: voiceID)
        
        let items: [ItemProtocol] = [RightDetailItem(title: "language".localized,
                                                     subtitle: languageService.current.description,
                                                     actionBlock: languageBlock),
                                     RightDetailItem(title: "accent_color".localized,
                                                     subtitle: accentColor,
                                                     actionBlock: accentColorBlock,
                                                     hasDisclosureItem: true),
                                     RightDetailItem(title: "voice".localized,
                                                     subtitle: voiceName,
                                                     actionBlock: voiceBlock,
                                                     hasDisclosureItem: true)].compactMap { $0 }
        return .init(header: "general".localized, items: items)
    }
    
    func setupPlaybackSpeedSection(playbackSpeedBlock: @escaping IntBlock) -> Section {
        let index = UserDefaults.shared.integer(for: .playbackSpeed)
        return .init(header: "speaking_rate".localized,
                     items: [SliderItem(leadingIcon: .tortoise,
                                        leadingAccessibilityText: "slower".localized,
                                        trailingIcon: .hare,
                                        trailingAccessibilityText: "faster".localized,
                                        steps: 5,
                                        index: index,
                                        playbackSpeedBlock: playbackSpeedBlock,
                                        isEnabled: FeatureToggle.isPaid)])
    }
    
    func setupLinksSection(rateBlock: @escaping ItemBlock,
                           privacyBlock: @escaping ItemBlock,
                           termsBlock: @escaping ItemBlock,
                           mailBlock: @escaping ItemBlock,
                           shareBlock: @escaping ItemBlock) -> Section {
        .init(header: "links".localized,
              items: [DisclosureItem(text: "rate_and_review".localized,
                                     actionBlock: rateBlock),
                      DisclosureItem(text: "privacy_policy".localized,
                                     actionBlock: privacyBlock),
                      DisclosureItem(text: "terms".localized,
                                     actionBlock: termsBlock),
                      DisclosureItem(text: "contact_us".localized,
                                     isEnabled: mailService.isMailAvailable,
                                     actionBlock: mailBlock),
                      DisclosureItem(text: "share_app".localized,
                                       actionBlock: shareBlock)])
    }
    
    func setupAboutSection(upgradeBlock: @escaping ItemBlock) -> Section {
        let version = Bundle.main.releaseVersionNumber ?? ""
        let name = Bundle.main.productName ?? ""
        let editionName = FeatureToggle.isPaid ? "\(name) Pro" : "\(name) Lite"
        
        return .init(header: "about".localized,
                     items: [RightDetailItem(title: "developer".localized,
                                             subtitle: "oleg_samoylov".localized,
                                             isEnabled: false),
                             RightDetailItem(title: "edition".localized,
                                             subtitle: editionName,
                                             actionBlock: upgradeBlock,
                                             hasDisclosureItem: false),
                             RightDetailItem(title: "version".localized,
                                             subtitle: version,
                                             isEnabled: false)])
    }
}
