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
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "Upgrade to Pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let resetItem = FeatureToggle.isPaid && FeatureToggle.isDebug ? ActionItem(text: "Downgrade".localized,
                                                                                   style: .standard,
                                                                                   actionBlock: resetBlock) : nil
        let header = FeatureToggle.isPaid ? "Deactivation".localized : "Activation".localized
        return .init(header: header, items: [upgradeItem, resetItem].compactMap { $0 })
    }
    
    func setupGeneralSection(languageBlock: @escaping ItemBlock,
                             accentColorBlock: @escaping ItemBlock,
                             notificationsBlock: @escaping BoolBlock) -> Section {
        let accentColor = AccentColor.current.rawValue.capitalized.localized
        let items: [ItemProtocol] =  [RightDetailItem(title: "Language".localized,
                                                      subtitle: languageService.current.description,
                                                      actionBlock: languageBlock),
                                      RightDetailItem(title: "Accent color".localized,
                                                      subtitle: accentColor,
                                                      actionBlock: accentColorBlock,
                                                      hasDisclosureItem: true,
                                                      isEnabled: FeatureToggle.isPaid)].compactMap { $0 }
        return .init(header: "General".localized, items: items)
    }
    
    func setupPlaybackSpeedSection(playbackSpeedBlock: @escaping IntBlock) -> Section {
        let index = UserDefaults.standard.integer(for: .playbackSpeed)
        return .init(header: "Playback speed".localized,
                     items: [SliderItem(leadingIcon: .tortoise,
                                        trailingIcon: .hare,
                                        steps: 5,
                                        index: index,
                                        playbackSpeedBlock: playbackSpeedBlock,
                                        isEnabled: FeatureToggle.isPaid)])
    }
    
    func setupVocabularySections(regularVerbsBlock: @escaping BoolBlock,
                                 derivativesBlock: @escaping BoolBlock) -> [Section] {
        [.init(header: "Vocabulary".localized,
               items: [SwitchItem(text: "Regular verbs (-ed)".localized,
                                  isOn: UserDefaults.standard.bool(for: .shouldRegularVerbsBeShown),
                                  isEnabled: FeatureToggle.isPaid,
                                  actionBlock: regularVerbsBlock)],
               footer: "RegularVerbsFooter".localized),
         .init(items: [SwitchItem(text: "Derivatives".localized,
                                  isOn: UserDefaults.standard.bool(for: .shouldDerivedFormsBeShown),
                                  isEnabled: FeatureToggle.isPaid,
                                  actionBlock: derivativesBlock)],
               footer: "DerivativesFooter".localized)]
    }
    
    func setupListSection(listViewModeBlock: @escaping ItemBlock) -> Section {
        .init(header: "List".localized,
              items: [setupListViewModeItem(listViewModeBlock: listViewModeBlock)].compactMap { $0 })
    }
    
    func setupTestsSection(testVerbsBlock: @escaping ItemBlock,
                           listeningBlock: @escaping BoolBlock) -> Section {
        .init(header: "Tests".localized,
              items: [
                setupTestVerbsItem(testVerbsBlock: testVerbsBlock),
                SwitchItem(text: "Listening".localized,
                           isOn: UserDefaults.standard.bool(for: .listening),
                           isEnabled: FeatureToggle.isPaid,
                           actionBlock: listeningBlock)].compactMap { $0 })
    }
    
    func setupLinksSection(rateBlock: @escaping ItemBlock,
                           privacyBlock: @escaping ItemBlock,
                           termsBlock: @escaping ItemBlock,
                           mailBlock: @escaping ItemBlock,
                           shareBlock: @escaping ItemBlock) -> Section {
        .init(header: "Links".localized,
              items: [DisclosureItem(text: "Rate and review".localized,
                                     actionBlock: rateBlock),
                      DisclosureItem(text: "Privacy policy".localized,
                                     actionBlock: privacyBlock),
                      DisclosureItem(text: "Terms of use".localized,
                                     actionBlock: termsBlock),
                      DisclosureItem(text: "Contact us".localized,
                                     isEnabled: mailService.isMailAvailable,
                                     actionBlock: mailBlock),
                      DisclosureItem(text: "Share the app".localized,
                                       actionBlock: shareBlock)])
    }
    
    func setupAboutSection(upgradeBlock: @escaping ItemBlock) -> Section {
        let version = Bundle.main.releaseVersionNumber ?? ""
        let name = Bundle.main.productName ?? ""
        let editionName = FeatureToggle.isPaid ? "\(name) Pro" : "\(name) Lite"
        
        return .init(header: "About".localized,
                     items: [RightDetailItem(title: "Developer".localized,
                                             subtitle: "Oleg Samoylov".localized,
                                             isEnabled: false),
                             RightDetailItem(title: "Edition".localized,
                                             subtitle: editionName,
                                             actionBlock: upgradeBlock,
                                             hasDisclosureItem: false),
                             RightDetailItem(title: "Version".localized,
                                             subtitle: version,
                                             isEnabled: false)])
    }
}

// MARK: - Private

private extension SettingsItemsFactory {
    
    func setupListViewModeItem(listViewModeBlock: @escaping ItemBlock) -> PickableItem? {
        let options = ["Verb forms".localized, "Translation".localized]
        let currentOption = !UserDefaults.standard.bool(for: .shouldTranslationBeShown)
            ? options.first
            : options.last
        return languageService.hasTranslation ? .init(title: "View".localized,
                                                      subtitle: currentOption ?? "",
                                                      actionBlock: listViewModeBlock,
                                                      options: options,
                                                      isEnabled: FeatureToggle.isPaid) : nil
    }
    
    func setupTestVerbsItem(testVerbsBlock: @escaping ItemBlock) -> ItemProtocol? {
        let options = ["All".localized, "Favorites".localized]
        let currentOption = !UserDefaults.standard.bool(for: .favoritesOnly)
            ? options.first
            : options.last
        return PickableItem(title: "Verbs".localized,
                            subtitle: currentOption ?? "",
                            actionBlock: testVerbsBlock,
                            options: options,
                            isEnabled: FeatureToggle.isPaid)
    }
}
