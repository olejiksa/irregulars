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
    
    var shouldRegularVerbsBeShown: Bool = true {
        didSet {
            setItems()
        }
    }
    
    var shouldDerivedFormsBeShown: Bool = true {
        didSet {
            setItems()
        }
    }
    
    var listView: Settings.ListView = .forms {
        didSet {
            setItems()
        }
    }
    
    init() {
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

private extension FavoritesService {
    
    func setItems() {
        var set: Set<Verb> = []
       
        if !shouldRegularVerbsBeShown {
            let elements = set.filter { $0.hasRegular }
            elements.forEach { set.remove($0) }
        }
        
        if !shouldDerivedFormsBeShown {
            let elements = set.filter { $0.isDerived }
            elements.forEach { set.remove($0) }
        }
        
        items = Array(set).sorted(by: <)
    }
}

