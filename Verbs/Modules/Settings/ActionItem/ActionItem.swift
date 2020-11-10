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
    let actionBlock: ((ItemProtocol) -> ())?
}

// MARK: - ItemProtocol

extension ActionItem: ItemProtocol {
    
    var identifier: String { ActionCell.identifier }
}

// MARK: - Actionable

extension ActionItem: Actionable {}

