//
//  PlainDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct PlainDetailItem {
    
    let text: String
    
    init(text: String) {
        self.text = text
    }
}

// MARK: - ItemProtocol

extension PlainDetailItem: ItemProtocol {
    
    var identifier: String { PlainDetailCell.identifier }
}
