//
//  VerbsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class VerbsService {
    
    var searchText = ""
    
    var searchedItems: [Verb] {
        return items.filter {
            $0.infinitive.containsIgnoringCase(searchText) ||
            $0.pastSimple.containsIgnoringCase(searchText) ||
            $0.pastParticiple?.containsIgnoringCase(searchText) ?? false ||
            $0.translation.containsIgnoringCase(searchText)
        }
    }
    
    var randomItem: Verb? { items.randomElement() }
    
    lazy var groupedItems: [[Verb]] = {
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
        return grouped
    }()
    
    var items: [Verb] = {
        let parser = JSONParser<Verb>()
        let set = Set(parser.read(from: "irregulars"))
        return Array(set).sorted(by: <)
    }()
}
