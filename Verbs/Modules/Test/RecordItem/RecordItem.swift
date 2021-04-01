//
//  RecordItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.04.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecordItem {
    
    let word: Word
    let playActionBlock: AudioBlock?
    let recordActionBlock: RecordBlock?
    let compareActionBlock: Block?
    var isFilled: Bool = false
    var isValid: Bool = false
    let tag: Int
    let returnKeyType: UIReturnKeyType
    
    init(word: Word,
         playActionBlock: AudioBlock? = nil,
         recordActionBlock: RecordBlock? = nil,
         compareActionBlock: Block? = nil,
         tag: Int,
         returnKeyType: UIReturnKeyType = .next) {
        self.word = word
        self.playActionBlock = playActionBlock
        self.recordActionBlock = recordActionBlock
        self.compareActionBlock = compareActionBlock
        self.tag = tag
        self.returnKeyType = returnKeyType
    }
}

// MARK: - ItemProtocol

extension RecordItem: ItemProtocol {
    
    var identifier: String { RecordCell.identifier }
}

