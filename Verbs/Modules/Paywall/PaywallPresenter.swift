//
//  PaywallPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class PaywallPresenter {
    
    let dataSource = SectionDataSource()
    
    init() {
        var items = [PaywallItem(text: "unlock_all_verbs_in_tests".localized,
                                 icon: .key),
                     PaywallItem(text: "listen_to_pronunciation".localized,
                                 icon: .speaker),
                     PaywallItem(text: "view_a_transcription".localized,
                                 icon: .transcription),
                     PaywallItem(text: "store_unlimited_items_in_favorites".localized,
                                 icon: .listStar),
                     PaywallItem(text: "personalize".localized,
                                 icon: .paintpalette),
                     PaywallItem(text: "one_time_payment".localized,
                                 icon: .creditcard)]
        
        #if targetEnvironment(macCatalyst)
        items.remove(at: 4)
        #endif
        
        dataSource.setup([.init(items: items)])
    }
}
