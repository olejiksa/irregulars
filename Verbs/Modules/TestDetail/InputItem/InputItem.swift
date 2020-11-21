//
//  InputItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct InputItem {
    
    let word: Word
    let successActionBlock: (() -> ())?
}

// MARK: - ItemProtocol

extension InputItem: ItemProtocol {
    
    var identifier: String { InputCell.identifier }
}
