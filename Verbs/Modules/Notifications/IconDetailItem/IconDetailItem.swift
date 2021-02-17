//
//  IconDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

struct IconDetailItem {
    
    let icon: SystemIcon
    let iconAccessibilityText: String
    let text: String
    
    init(icon: SystemIcon,
         iconAccessibilityText: String,
         text: String) {
        self.icon = icon
        self.iconAccessibilityText = iconAccessibilityText
        self.text = text
    }
}

// MARK: - ItemProtocol

extension IconDetailItem: ItemProtocol {
    
    var identifier: String { IconDetailCell.identifier }
}
