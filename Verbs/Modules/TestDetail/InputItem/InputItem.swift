//
//  InputItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class InputItem {
    
    let word: Word
    let successActionBlock: Block
    let playActionBlock: ((String, @escaping Block, @escaping Block) -> ())
    let hintActionBlock: ((String) -> ())
    let isAudio: Bool
    var isFilled: Bool = false
    
    init(word: Word,
         playActionBlock: @escaping ((String, @escaping Block, @escaping Block) -> ()),
         successActionBlock: @escaping Block,
         hintActionBlock: @escaping ((String) -> ()),
         isAudio: Bool = false) {
        self.word = word
        self.playActionBlock = playActionBlock
        self.successActionBlock = successActionBlock
        self.hintActionBlock = hintActionBlock
        self.isAudio = isAudio
    }
}

// MARK: - ItemProtocol

extension InputItem: ItemProtocol {
    
    var identifier: String { InputCell.identifier }
}
