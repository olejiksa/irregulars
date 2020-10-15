//
//  Verb.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Verb: Decodable {
    
    let infinitive: String
    let pastSimple: String
    let pastParticiple: String?
    let hasRegular: Bool
    let isDerived: Bool
    
    var translation: String { infinitive.localized }
    var url: URL? { URL(string: "verbs://\(infinitive)") }
    
    var pastSimpleShortened: String {
        guard let shortened = pastSimple.split(separator: "/").first else { return pastSimple }
        return String(shortened)
    }
    
    var pastParticipleShortened: String? {
        guard
            let pastParticiple = pastParticiple,
            let shortened = pastParticiple.split(separator: "/").first
        else { return nil }
        
        return String(shortened)
    }
}

// MARK: - Comparable

extension Verb: Comparable {
    
    static func <(lhs: Verb, rhs: Verb) -> Bool {
        lhs.infinitive < rhs.infinitive
    }
}

// MARK: - Hashable

extension Verb: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(infinitive)
    }
}
