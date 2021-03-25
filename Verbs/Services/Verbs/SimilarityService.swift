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
}
