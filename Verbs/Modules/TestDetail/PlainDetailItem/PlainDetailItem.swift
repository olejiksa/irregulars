//
//  PlainDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct PlainDetailItem {
    
    let word: Word
    
    init?(word: Word?) {
        guard let word = word else { return nil }
        self.word = word
    }
}

// MARK: - ItemProtocol

extension PlainDetailItem: ItemProtocol {
    
    var identifier: String { PlainDetailCell.identifier }
}
