//
//  SimilarityService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class SimilarityService {
    
    private let parser = JSONParser<[String]>()
    private(set) var items: [[String]] = []
    
    init() {
        items = parser.read(from: .similars)
    }
    
    func similar(basedOn verb: Verb) -> Verb {
        guard let arrayIndex = items.firstIndex(where: { $0.contains(verb.infinitive.value) }) else { return verb }
        let similarity = Similarity(rawValue: arrayIndex) ?? .others
        return Verb(verb: verb, similarity: similarity)
    }
}
