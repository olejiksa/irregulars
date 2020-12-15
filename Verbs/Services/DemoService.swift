//
//  DemoService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 15.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class DemoService {
    
    private let parser = JSONParser<String>()

    private(set) var items: [String] = []
    
    init() {
        setItems()
    }
}

// MARK: - Private

private extension DemoService {
    
    func setItems() {
        items = parser.read(from: .demo)
    }
}
