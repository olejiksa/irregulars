//
//  AnswerItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 13.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct AnswerItem {
    
    let text: String
    let actionBlock: ItemBlock?
    let isCorrect: Bool
    
    init(text: String, actionBlock: ItemBlock?, isCorrect: Bool = false) {
        self.text = text
        self.actionBlock = actionBlock
        self.isCorrect = isCorrect
    }
}

// MARK: - ItemProtocol

extension AnswerItem: ItemProtocol {
    
    var identifier: String { AnswerCell.identifier }
}

// MARK: - Hashable

extension AnswerItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text.hashValue ^ isCorrect.hashValue)
    }
}

// MARK: - Equatable

extension AnswerItem: Equatable {

    static func == (lhs: AnswerItem, rhs: AnswerItem) -> Bool {
        lhs.text == rhs.text && lhs.isCorrect == rhs.isCorrect
    }
}

// MARK: - Actionable

extension AnswerItem: Actionable {}
