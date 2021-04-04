//
//  SimilarityService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class SimilarityService {
    
    func similar(basedOn verb: Verb) -> Verb {
        let hasEnSuffix = verb.pastParticiple?.first?.value.hasSuffix("en") ?? false
        let hasOwnSuffix = verb.pastParticiple?.first?.value.hasSuffix("own") ?? false
        let hasAwnSuffix = verb.pastParticiple?.first?.value.hasSuffix("awn") ?? false
        
        let similarity: Similarity
        if verb.infinitive == verb.simplePast?.first, verb.simplePast?.first == verb.pastParticiple?.first {
            similarity = .all
        } else if hasEnSuffix {
            similarity = .thirdEn
        } else if verb.pastParticiple?.first == verb.infinitive {
            similarity = .firstAndThird
        } else if verb.simplePast?.first == verb.pastParticiple?.first {
            similarity = .secondAndThird
        } else if hasOwnSuffix || hasAwnSuffix {
            similarity = .thirdOwnAndAwn
        } else {
            similarity = .others
        }
        
        return .init(verb: verb, similarity: similarity)
    }
}
