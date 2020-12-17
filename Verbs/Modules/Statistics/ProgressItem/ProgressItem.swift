//
//  ProgressItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct ProgressItem {
    
    let value: Int
    let maximum: Int
}

// MARK: - ItemProtocol

extension ProgressItem: ItemProtocol {
    
    var identifier: String { ProgressCell.identifier }
}
