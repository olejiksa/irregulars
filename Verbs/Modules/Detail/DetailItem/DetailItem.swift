//
//  DetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct DetailItem {
    
    let word: Word
    let actionBlock: ((String, @escaping () -> Void, @escaping () -> Void) -> ())
    
    init?(word: Word?,
          actionBlock: @escaping ((String, @escaping () -> Void, @escaping () -> Void) -> ())) {
        guard let word = word else { return nil }
        self.word = word
        self.actionBlock = actionBlock
    }
}

// MARK: - ItemProtocol

extension DetailItem: ItemProtocol {
    
    var identifier: String { DetailCell.identifier }
}
