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
    
    func setSimilarity(for verb: inout Verb) {
        guard let arrayIndex = items.firstIndex(where: { $0.contains(verb.infinitive.value) }) else { return }
        let similarity = Similarity(rawValue: arrayIndex)
        verb.similarity = similarity
    }
}
