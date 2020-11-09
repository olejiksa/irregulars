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
            $0.infinitive.value.containsIgnoringCase(searchText) ||
            $0.simplePast.contains { $0.value.containsIgnoringCase(searchText) } ||
            $0.pastParticiple?.contains { $0.value.containsIgnoringCase(searchText) } ?? false ||
            $0.translation.containsIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }

    var items: [Verb] = []
    
    var listView: Settings.ListView = .forms {
        didSet {
            setItems()
        }
    }
    
    init() {
        setupFavorites()
        setItems()
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
        favorites?.didUpdateBlock = { [weak self] in self?.setItems() }
    }
    
    func setItems() {
        guard let favorites = favorites else { return }
        let set = Set(parser.read(from: "irregulars"))
        items = Array(set.intersection(favorites.verbs)).sorted(by: <)
    }
}
