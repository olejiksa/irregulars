//
//  SpotlightService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

final class SpotlightService {
    
    private var isIndexed = false
    private let searchableIndex = CSSearchableIndex.default()
    
    func setupSpotlight(with verbs: [Verb]) {
        guard !isIndexed else { return }
        
        let searchableItems: [CSSearchableItem] = verbs.map {
            let infinitive = "\($0.infinitive.value) \($0.infinitive.transcription)"
            let simplePast = $0.simplePast?
                .compactMap { "\($0.value) \($0.transcription)" }
                .joined(separator: " | ") ?? ""
            let pastParticiple = $0.pastParticiple?
                .compactMap { "\($0.value) \($0.transcription)" }
                .joined(separator: " | ") ?? ""
            let contentDescription = simplePast + "\n" + pastParticiple
            
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = infinitive
            searchableItemAttributeSet.contentDescription = contentDescription
            searchableItemAttributeSet.identifier = $0.infinitive.value
            searchableItemAttributeSet.relatedUniqueIdentifier = $0.infinitive.value
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.olejiksa.Verbs.\($0.infinitive.value)",
                domainIdentifier: "com.olejiksa.Verbs",
                attributeSet: searchableItemAttributeSet)
            
            return searchableItem
        }
        
        searchableIndex.indexSearchableItems(searchableItems) { [weak self] error in
            guard let error = error else {
                self?.isIndexed = true
                return
            }
            
            print(error.localizedDescription)
        }
    }
}
