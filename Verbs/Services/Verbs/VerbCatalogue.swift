//
//  VerbCatalogue.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

/// The one place that knows the verbs. Screens pick what they want from it rather
/// than each holding a service with its own copy of the display settings.
@MainActor
@Observable
final class VerbCatalogue {
    
    /// Every verb in the bundle, classified and sorted. It cannot change while the app runs.
    let allVerbs: [Verb]
    
    @ObservationIgnored private let favorites: Favorites
    
    init(favorites: Favorites = Locator.favorites) {
        self.favorites = favorites
        allVerbs = VerbsStore.all.sorted(by: <)
    }
    
    // MARK: Picking
    
    func verbs(favoritesOnly: Bool = false,
               includingRegular: Bool = true,
               includingDerived: Bool = true) -> [Verb] {
        var verbs = favoritesOnly
            ? allVerbs.filter(favorites.verbs.contains)
            : allVerbs
        
        if !includingRegular {
            verbs.removeAll(where: \.hasRegular)
        }
        
        if !includingDerived {
            verbs.removeAll(where: \.isDerived)
        }
        
        return verbs
    }
    
    func verb(named infinitive: String?) -> Verb? {
        allVerbs.first { $0.infinitive.value == infinitive }
    }
    
    // MARK: Shaping
    
    func search(_ text: String, in verbs: [Verb]) -> [Verb] {
        verbs.filter {
            $0.infinitive.value.hasPrefixIgnoringCase(text) ||
            $0.simplePast?.contains { $0.value.hasPrefixIgnoringCase(text) } ?? false ||
            $0.pastParticiple?.contains { $0.value.hasPrefixIgnoringCase(text) } ?? false ||
            $0.translation.containsWordIgnoringCase(text)
        }
    }
    
    /// Groups and headers together, so a caller cannot get one without the other.
    func grouped(_ verbs: [Verb], bySimilarity: Bool) -> (groups: [[Verb]], headers: [String]) {
        guard !bySimilarity else {
            let grouped = Dictionary(grouping: verbs) { $0.similarity ?? .others }
            let sorted = grouped.sorted { $0.key < $1.key }
            return (sorted.map(\.value), sorted.map(\.key.description))
        }
        
        var groups = [[Verb]]()
        var letter: Character?
        
        for verb in verbs {
            if verb.infinitive.value.first != letter {
                letter = verb.infinitive.value.first
                groups.append([])
            }
            
            groups[groups.count - 1].append(verb)
        }
        
        let headers = groups.compactMap { $0.first?.infinitive.value.first }.map { String($0.uppercased()) }
        return (groups, headers)
    }
}
