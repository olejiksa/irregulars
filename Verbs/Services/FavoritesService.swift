//
//  FavoritesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class FavoritesService {
    
    private let parser = JSONParser<Verb>()
    private var favorites: Favorites?
    
    var searchText = ""
    
    var searchedItems: [Verb] {
        items.filter {
            $0.infinitive.value.hasPrefixIgnoringCase(searchText) ||
            $0.simplePast.contains { $0.value.hasPrefixIgnoringCase(searchText) } ||
            $0.pastParticiple?.contains { $0.value.hasPrefixIgnoringCase(searchText) } ?? false ||
            $0.translation.hasPrefixIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }

    var items: [Verb] = []
    var groupedItems: [[Verb]] = []
    
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
        for index in 0..<items.count {
            if items[index].infinitive.value == infinitive {
                indexPath = IndexPath(row: index, section: 0)
            }
        }
        
        return indexPath
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
