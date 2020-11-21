//
//  DetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct DetailItem {
    
    let word: Word
    let actionBlock: ((String) -> ())?
    
    init?(word: Word?,
          actionBlock: ((String) -> ())? = nil) {
        guard let word = word else { return nil }
        self.word = word
        self.actionBlock = actionBlock
    }
}

// MARK: - ItemProtocol

extension DetailItem: ItemProtocol {
    
    var identifier: String { DetailCell.identifier }
}
