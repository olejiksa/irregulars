//
//  SwitchItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct SwitchItem {
    
    let text: String
    var isOn: Bool
    let actionBlock: ((Bool) -> ())
}

// MARK: - ItemProtocol

extension SwitchItem: ItemProtocol {
    
    var identifier: String { SwitchCell.identifier }
}
