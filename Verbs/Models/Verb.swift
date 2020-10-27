//
//  Verb.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Verb: Decodable {
    
    let infinitive: Word
    let simplePast: [Word]
    let pastParticiple: [Word]?
    let hasRegular: Bool
    let isDerived: Bool
    
    var translation: String { infinitive.value.localized }
    var url: URL? { URL(string: "verbs://\(infinitive.value)") }
}

// MARK: - Comparable

extension Verb: Comparable {
    
    static func <(lhs: Verb, rhs: Verb) -> Bool {
        lhs.infinitive.value < rhs.infinitive.value
    }
}

// MARK: - Hashable

extension Verb: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(infinitive.value)
    }
}
