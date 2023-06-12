//
//  PhrasalsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/12/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

final class PhrasalsService {
    
    private let parser = JSONParser<String>()

    private(set) var items: [String] = []
    
    init() {
        setItems()
    }
}

// MARK: - Private

private extension PhrasalsService {
    
    func setItems() {
        items = parser.read(from: .phrasals)
    }
}
