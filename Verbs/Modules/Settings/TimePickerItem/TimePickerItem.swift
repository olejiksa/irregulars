//
//  TimePickerItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class TimePickerItem {
    
    let title: String
    let actionBlock: ItemBlock?
    let isEnabled: Bool
    
    init(title: String,
         actionBlock: ItemBlock? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.actionBlock = actionBlock
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension TimePickerItem: ItemProtocol {
    
    var identifier: String { TimePickerCell.identifier }
}

// MARK: - Actionable

extension TimePickerItem: Actionable {}

