//
//  SimilarityService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class SimilarityService {
    
    func similar(basedOn verb: Verb) -> Verb {
        let secondSet = Set(verb.simplePast ?? [])
        let thirdSet = Set(verb.pastParticiple ?? [])
        let secondAndThirdIntersection = secondSet.intersection(thirdSet)
        let areIntersected = !secondAndThirdIntersection.isEmpty
        
        let similarity: Similarity
        if verb.simplePast?.contains(verb.infinitive) == true, areIntersected {
            similarity = .all
        } else if verb.pastParticiple?.contains(where: { $0.value.hasSuffix("en") }) == true {
            similarity = .thirdEn
        } else if verb.pastParticiple?.contains(verb.infinitive) == true {
            similarity = .firstAndThird
        } else if areIntersected {
            similarity = .secondAndThird
        } else if verb.pastParticiple?.contains(where: { $0.value.hasSuffix("own") || $0.value.hasSuffix("awn") }) == true {
            similarity = .thirdOwnAndAwn
        } else {
            similarity = .others
        }
        
        return .init(verb: verb, similarity: similarity)
    }
}
