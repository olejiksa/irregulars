//
//  VerbsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class VerbsService {
    
    private let parser = JSONParser<Verb>()
    
    var searchText = ""
    
    var searchedItems: [Verb] {
        items.filter {
            $0.infinitive.containsIgnoringCase(searchText) ||
            $0.pastSimple.containsIgnoringCase(searchText) ||
            $0.pastParticiple?.containsIgnoringCase(searchText) ?? false ||
            $0.translation.containsIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }
    
    var items: [Verb] = []
    var groupedItems: [[Verb]] = []
    
    var shouldRegularVerbsBeShown: Bool = true {
        didSet {
            setItems()
            setGroupedItems()
        }
    }
    
    init() {
        setItems()
        setGroupedItems()
    }
}

extension VerbsService {
    
    func setItems() {
        var set = Set(parser.read(from: "irregulars"))
        if !shouldRegularVerbsBeShown {
            let elements = set.filter { $0.hasRegular }
            elements.forEach { set.remove($0) }
        }
        
        items = Array(set).sorted(by: <)
    }
    
    func setGroupedItems() {
        var grouped = [[Verb]]()
        var letter: Character?
        var index = -1
        for item in items {
            if item.infinitive.first != letter {
                letter = item.infinitive.first
                grouped.append([Verb]())
                index += 1
            }
            grouped[index].append(item)
        }
        
        groupedItems = grouped
    }
}
