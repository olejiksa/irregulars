//
//  PaywallPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class PaywallPresenter {
    
    let dataSource = SectionDataSource()
    
    init(languageService: LanguageService) {
        let item = languageService.hasTranslation
            ? PaywallItem(text: "View a translation without going to the verb card".localized,
                          icon: .dictionary)
            : nil
        
        let items = [PaywallItem(text: "Unlock all verbs in tests".localized,
                                 icon: .key),
                     PaywallItem(text: "Listen to pronunciation".localized,
                                 icon: .speaker),
                     PaywallItem(text: "View a transcription".localized,
                                 icon: .transcription),
                     PaywallItem(text: "Store unlimited items in Favorites".localized,
                                 icon: .starFill),
                     PaywallItem(text: "Personalize the app: pick an accent color to your liking".localized,
                                 icon: .paintpalette),
                     PaywallItem(text: "Hide or show regular verbs (-ed)".localized,
                                 icon: .eye),
                     PaywallItem(text: "Hide or show derivatives".localized,
                                 icon: .eye),
                     item]
        
        dataSource.setup([Section(items: items.compactMap { $0 })])
    }
}
