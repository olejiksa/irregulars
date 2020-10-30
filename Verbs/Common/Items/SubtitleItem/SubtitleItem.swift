//
//  SubtitleItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct SubtitleItem {
    
    let title: String
    let subtitle: String
    let hasDisclosureIndicator: Bool
    
    init(title: String,
         subtitle: String,
         hasDisclosureIndicator: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.hasDisclosureIndicator = hasDisclosureIndicator
    }
}

// MARK: - ItemProtocol

extension SubtitleItem: ItemProtocol {
    
    var identifier: String { SubtitleCell.identifier }
}
