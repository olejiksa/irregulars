//
//  ListItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct ListItem {
    
    let verb: Verb
}

// MARK: - ItemProtocol

extension ListItem: ItemProtocol {
    
    var identifier: String { ListCell.identifier }
}

