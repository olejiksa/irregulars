//
//  ExampleItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct ExampleItem {
    
    let sentence: String
    let verb: Verb
}

// MARK: - ItemProtocol

extension ExampleItem: ItemProtocol {
    
    var identifier: String { ExampleCell.identifier }
}
