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

    private(set) var items: [Verb] = []
    private(set) var groupedItems: [[Verb]] = []
    private(set) var headers: [String] = []
    
    var shouldTranslationBeShown: Bool = false {
        didSet {
            setItems()
            setGroupedItems()
        }
    }
    
    var shouldDerivativesBeShown: Bool = false
    var shouldRegularVerbsBeShown: Bool = false
    
    var shouldSimilarBeShown: Bool = false {
        didSet {
            setItems()
            setGroupedItems()
        }
    }
    
    init() {
        setupFavorites()
        setItems()
        setGroupedItems()
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
    
    func setupFavorites() {
        Locator.favorites.didUpdateBlock = { [weak self] in
            self?.setItems()
            self?.setGroupedItems()
        }
    }
    
    func setItems() {
//        #if DEBUG
//        items = VerbsService().items.filter { ["get", "go", "make", "slit", "strew", "teach", "vex"].contains($0.infinitive.value) }
//        #else
        let set = VerbsStore.all
        
        items = Array(set.intersection(Locator.favorites.verbs)).sorted(by: <)
//        #endif
    }
    
    func setGroupedItems() {
        groupedItems = !shouldSimilarBeShown ?
            groupedItemsAlphabetically() :
            groupedItemsBySimilarity()
    }
    
    func groupedItemsAlphabetically() -> [[Verb]] {
        var grouped = [[Verb]]()
        var letter: Character?
        var index = -1
        for item in items {
            if item.infinitive.value.first != letter {
                letter = item.infinitive.value.first
                grouped.append([Verb]())
                index += 1
            }
            grouped[index].append(item)
        }
        
        headers = grouped.map(\.first?.infinitive.value).compactMap {
            guard let letter = $0?.first else { return nil }
            return String(letter.uppercased())
        }
        
        return grouped
    }
    
    func groupedItemsBySimilarity() -> [[Verb]] {
        let grouped = Dictionary(grouping: items) { $0.similarity ?? .others }
        let array = Array(grouped).sorted { $0.key < $1.key }
        headers = array.map(\.key.description)
        return array.map(\.value)
    }
}
