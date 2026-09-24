//
//  FavoritesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

@MainActor
final class FavoritesService: VerbsServiceProtocol {
    
    
    var favoritesOnly: Bool { true }
    
    var searchText = ""
    
    var searchedItems: [Verb] {
        items.filter {
            $0.infinitive.value.hasPrefixIgnoringCase(searchText) ||
            $0.simplePast?.contains { $0.value.hasPrefixIgnoringCase(searchText) } ?? false ||
            $0.pastParticiple?.contains { $0.value.hasPrefixIgnoringCase(searchText) } ?? false ||
            $0.translation.containsWordIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }

    /// Derived on demand: the favourites are observable, so there is nothing to cache.
    var items: [Verb] {
        Array(VerbsStore.all.intersection(Locator.favorites.verbs)).sorted(by: <)
    }
    
    var groupedItems: [[Verb]] { grouping.groups }
    var headers: [String] { grouping.headers }
    
    var shouldTranslationBeShown: Bool = false {
        didSet {
        }
    }
    
    var shouldDerivativesBeShown: Bool = false
    var shouldRegularVerbsBeShown: Bool = false
    
    var shouldSimilarBeShown: Bool = false {
        didSet {
        }
    }
    
    init() {
    }
    
    func indexPath(of infinitive: String?) -> IndexPath? {
        var indexPath: IndexPath?
        for index in 0..<groupedItems.count {
            for subindex in 0..<groupedItems[index].count {
                if groupedItems[index][subindex].infinitive.value == infinitive {
                    indexPath = IndexPath(row: subindex, section: index)
                }
            }
        }
        
        return indexPath
    }
    
    func verb(of infinitive: String?) -> Verb? {
        items.first { $0.infinitive.value == infinitive }
    }
}

// MARK: - Private

private extension FavoritesService {
    
    /// Groups and headers come from one place, so a reader cannot get one without the other.
    var grouping: (groups: [[Verb]], headers: [String]) {
        guard !shouldSimilarBeShown else {
            let grouped = Dictionary(grouping: items) { $0.similarity ?? .others }
            let sorted = Array(grouped).sorted { $0.key < $1.key }
            return (sorted.map(\.value), sorted.map(\.key.description))
        }
        
        var groups = [[Verb]]()
        var letter: Character?
        
        for item in items {
            if item.infinitive.value.first != letter {
                letter = item.infinitive.value.first
                groups.append([])
            }
            
            groups[groups.count - 1].append(item)
        }
        
        let headers = groups.compactMap { $0.first?.infinitive.value.first }.map { String($0.uppercased()) }
        return (groups, headers)
    }
    
    
    
    
    
}
