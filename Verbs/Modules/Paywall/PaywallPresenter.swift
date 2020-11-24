//
//  PaywallPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class PaywallPresenter {
    
    let dataSource = SectionDataSource()
    
    private let languageService = LanguageService()
    
    init() {
        let item = LanguageService().hasTranslation
            ? PaywallItem(text: "View a translation without going to the verb page".localized,
                          icon: .dictionary)
            : nil
        
        let items = [PaywallItem(text: "Get access to all tests".localized,
                                 icon: .note),
                     PaywallItem(text: "Listen to pronunciation".localized,
                                 icon: .speaker),
                     PaywallItem(text: "See a transcription".localized,
                                 icon: .transcription),
                     PaywallItem(text: "Add unlimited items in Favorites".localized,
                                 icon: .listStar),
                     PaywallItem(text: "Find words faster using search".localized,
                                 icon: .search),
                     PaywallItem(text: "Find words faster using the alphabetical scrollbar".localized,
                                 icon: .alphabet),
                     PaywallItem(text: "Hide or show regular verbs (-ed)".localized,
                                 icon: .toggle),
                     PaywallItem(text: "Hide or show derivatives".localized,
                                 icon: .toggle),
                     item]
        
        dataSource.setup([Section(header: nil, items: items.compactMap { $0 })])
    }
}
