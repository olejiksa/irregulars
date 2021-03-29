//
//  Verb.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Verb: Codable {
    
    enum Form: CaseIterable {
        case infinitive
        case simplePast
        case pastParticiple
        case translation
    }
    
    let infinitive: Word
    let simplePast: [Word]?
    let pastParticiple: [Word]?
    let hasRegular: Bool
    let isDerived: Bool
    let similarity: Similarity?
    
    var translation: String { infinitive.value.localized.lowercased() }
    var url: URL? { URL(string: "verbs://\(infinitive.value)") }
    
    init(infinitive: Word,
         simplePast: [Word]? = nil,
         pastParticiple: [Word]? = nil,
         hasRegular: Bool = false,
         isDerived: Bool = false,
         similarity: Similarity = .others) {
        self.infinitive = infinitive
        self.simplePast = simplePast
        self.pastParticiple = pastParticiple
        self.hasRegular = hasRegular
        self.isDerived = isDerived
        self.similarity = similarity
    }
    
    init(verb: Verb, similarity: Similarity? = nil) {
        self.infinitive = verb.infinitive
        self.simplePast = verb.simplePast
        self.pastParticiple = verb.pastParticiple
        self.hasRegular = verb.hasRegular
        self.isDerived = verb.isDerived
        self.similarity = similarity ?? verb.similarity
    }
}

// MARK: - Comparable

extension Verb: Comparable {
    
    static func <(lhs: Verb, rhs: Verb) -> Bool {
        lhs.infinitive.value < rhs.infinitive.value
    }
}

// MARK: - Equatable

extension Verb: Equatable {
    
    static func ==(lhs: Verb, rhs: Verb) -> Bool {
        lhs.infinitive.value == rhs.infinitive.value
    }
}

// MARK: - Hashable

extension Verb: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(infinitive.value)
    }
}
