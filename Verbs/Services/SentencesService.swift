//
//  SentencesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class SentencesService {
    
    private let parser = JSONParser<Sentence>()

    private(set) var items: [Sentence] = []
    
    init() {
        setItems()
    }
}

// MARK: - Private

private extension SentencesService {
    
    func setItems() {
        items = parser.read(from: .sentences)
    }
}
