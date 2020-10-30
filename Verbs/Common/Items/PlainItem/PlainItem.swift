//
//  PlainItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct PlainItem {
    
    let title: String
    let hasDisclosureIndicator: Bool
    
    init(title: String,
         hasDisclosureIndicator: Bool = false) {
        self.title = title
        self.hasDisclosureIndicator = hasDisclosureIndicator
    }
}

// MARK: - ItemProtocol

extension PlainItem: ItemProtocol {
    
    var identifier: String { PlainCell.identifier }
}

