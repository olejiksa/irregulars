//
//  StatisticsHeaderItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct StatisticsHeaderItem {
    
    let title: String
    let subtitle: String
}

// MARK: - ItemProtocol

extension StatisticsHeaderItem: ItemProtocol {
    
    var identifier: String { StatisticsHeaderCell.identifier }
}
