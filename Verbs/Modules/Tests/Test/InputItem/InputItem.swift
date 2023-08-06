//
//  InputItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class InputItem {
    
    let words: [Word]
    let successActionBlock: Block
    let playActionBlock: AudioBlock?
    let hintActionBlock: ((String) -> ())
    let isAudio: Bool
    var isFilled: Bool = false
    var isValid: Bool = false
    let tag: Int
    let returnKeyType: UIReturnKeyType
    
    init(words: [Word],
         playActionBlock: AudioBlock? = nil,
         successActionBlock: @escaping Block,
         hintActionBlock: @escaping ((String) -> ()),
         isAudio: Bool = false,
         tag: Int,
         returnKeyType: UIReturnKeyType = .next) {
        self.words = words
        self.playActionBlock = playActionBlock
        self.successActionBlock = successActionBlock
        self.hintActionBlock = hintActionBlock
        self.isAudio = isAudio
        self.tag = tag
        self.returnKeyType = returnKeyType
    }
}

// MARK: - ItemProtocol

extension InputItem: ItemProtocol {
    
    var identifier: String { InputCell.identifier }
}
