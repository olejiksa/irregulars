//
//  SwitchItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SwitchItem {
    
    let text: String
    var isOn: Bool
    var isEnabled: Bool
    let actionBlock: BoolBlock
    
    init(text: String,
         isOn: Bool,
         isEnabled: Bool = true,
         actionBlock: @escaping BoolBlock) {
        self.text = text
        self.isOn = isOn
        self.isEnabled = isEnabled
        self.actionBlock = actionBlock
    }
}

// MARK: - ItemProtocol

extension SwitchItem: ItemProtocol {
    
    var identifier: String { SwitchCell.identifier }
}
