//
//  VerbsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class VerbsService: VerbsServiceProtocol {
    
    private let parser = JSONParser<Verb>()
    
    var searchText = ""
    
    var searchedItems: [Verb] {
        items.filter {
            $0.infinitive.value.hasPrefixIgnoringCase(searchText) ||
            $0.simplePast?.contains { $0.value.hasPrefixIgnoringCase(searchText) } ?? false ||
            $0.pastParticiple?.contains { $0.value.hasPrefixIgnoringCase(searchText) } ?? false ||
            $0.translation.containsIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }

    private(set) var items: [Verb] = []
    private(set) var groupedItems: [[Verb]] = []
    
    var shouldRegularVerbsBeShown: Bool = true {
        didSet {
            setItems()
            setGroupedItems()
        }
    }
    
    var shouldDerivedFormsBeShown: Bool = true {
        didSet {
            setItems()
            setGroupedItems()
        }
    }
    
    var shouldTranslationBeShown: Bool = false {
        didSet {
            setGroupedItems()
        }
    }
    
    init() {
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

private extension VerbsService {
    
    func setItems() {
        var set = Set(parser.read(from: .irregulars))
       
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
