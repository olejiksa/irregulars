//
//  MistakeItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

struct MistakeItem {
    
    let verb: Verb
    let actionBlock: BoolBlock?
}

// MARK: - ItemProtocol

extension MistakeItem: ItemProtocol {
    
    var identifier: String { MistakeCell.identifier }
}
