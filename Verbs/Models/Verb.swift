//
//  Verb.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Verb: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case infinitive = "Base"
        case pastSimple = "Past-simple"
        case pastParticiple = "Past-Participle"
    }
    
    let infinitive: String
    let pastSimple: String
    let pastParticiple: String?
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

// MARK: - CustomStringConvertible

extension Verb: CustomStringConvertible {
    
    var description: String {
        if let pastParticiple = pastParticiple {
            return "\(pastSimple), \(pastParticiple)"
        } else {
            return "\(pastSimple)"
        }
    }
}
