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
}

// MARK: - ItemProtocol

extension SubtitleItem: ItemProtocol {
    
    var identifier: String { SubtitleCell.identifier }
}

