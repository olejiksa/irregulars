//
//  AccentColorItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class AccentColorItem {
    
    let color: AccentColor
    
    init(color: AccentColor) {
        self.color = color
    }
}

// MARK: - ItemProtocol

extension AccentColorItem: ItemProtocol {
    
    var identifier: String { AccentColorCell.identifier }
}
