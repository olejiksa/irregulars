//
//  FavoritesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class FavoritesService: VerbsServiceProtocol {
    
    private let parser = JSONParser<Verb>()
    private var favorites: Favorites?
    
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
    
    var shouldTranslationBeShown: Bool = false {
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
        favorites = Locator.favorites
        favorites?.didUpdateBlock = { [weak self] in
            self?.setItems()
            self?.setGroupedItems()
        }
    }
    
    func setItems() {
        guard let favorites = favorites else { return }
        let set = Set(parser.read(from: .irregulars))
        items = Array(set.intersection(favorites.verbs)).sorted(by: <)
    }
    
    func setGroupedItems() {
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
        
        groupedItems = grouped
    }
}
