//
//  ActionItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct ActionItem {
    
    enum Style {
        case standard
        case destructive
    }
    
    let text: String
    let style: Style
    let isEnabled: Bool
    let actionBlock: ItemBlock?
    
    init(text: String,
         style: Style = .standard,
         isEnabled: Bool = true,
         actionBlock: ItemBlock? = nil) {
        self.text = text
        self.style = style
        self.isEnabled = isEnabled
        self.actionBlock = actionBlock
    }
}

// MARK: - ItemProtocol

extension ActionItem: ItemProtocol {
    
    var identifier: String { ActionCell.identifier }
}

// MARK: - Actionable

extension ActionItem: Actionable {}

