//
//  VerbsStore.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

enum VerbsStore {
    
    /// The bundled verbs, decoded and classified once. The file cannot change while
    /// the app runs, and the services below rebuild their contents on every setting
    /// change, which used to decode it again each time.
    static let all: Set<Verb> = {
        let similarityService = SimilarityService()
        let verbs = JSONParser<Verb>().read(from: .irregulars)
        return Set(Set(verbs).map(similarityService.similar))
    }()
}
