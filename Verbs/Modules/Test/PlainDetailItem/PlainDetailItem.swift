//
//  PlainDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct PlainDetailItem {
    
    enum TextStyle {
        case standard
        case caption
    }
    
    let text: String
    let textStyle: TextStyle
    
    init(text: String, textStyle: TextStyle = .standard) {
        self.text = text
        self.textStyle = textStyle
    }
}

// MARK: - ItemProtocol

extension PlainDetailItem: ItemProtocol {
    
    var identifier: String { PlainDetailCell.identifier }
}
