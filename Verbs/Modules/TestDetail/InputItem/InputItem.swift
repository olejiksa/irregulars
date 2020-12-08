//
//  InputItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class InputItem {
    
    let words: [Word]
    let successActionBlock: Block
    let playActionBlock: ((String, @escaping Block, @escaping Block) -> ())?
    let hintActionBlock: ((String) -> ())
    let isAudio: Bool
    var isFilled: Bool = false
    
    init(words: [Word],
         playActionBlock: ((String, @escaping Block, @escaping Block) -> ())? = nil,
         successActionBlock: @escaping Block,
         hintActionBlock: @escaping ((String) -> ()),
         isAudio: Bool = false) {
        self.words = words
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
