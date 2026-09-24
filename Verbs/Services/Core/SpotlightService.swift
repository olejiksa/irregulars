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
        
        // Claimed up front: indexing is asynchronous, and the callers change several
        // settings in a row, so the flag would otherwise still be false on each call.
        isIndexed = true
        
        let searchableItems: [CSSearchableItem] = verbs.map {
            let infinitive = "\($0.infinitive.value)"
            let simplePast = $0.simplePast?.map(\.value).joined(separator: ", ") ?? ""
            let pastParticiple = $0.pastParticiple?.map(\.value).joined(separator: ", ") ?? ""
            let contentDescription = pastParticiple.isEmpty ? simplePast : simplePast + "\n" + pastParticiple
            
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.data.identifier)
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
            guard let error = error else { return }
            
            // Let a later call try again.
            self?.isIndexed = false
            print(error.localizedDescription)
        }
    }
}
