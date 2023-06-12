//
//  TimePickerItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class TimePickerItem {
    
    let title: String
    let action: IntBlock
    let scrollingBlock: CellBlock
    let value: Int
    let isEnabled: Bool
    
    init(title: String,
         action: @escaping IntBlock,
         scrollingBlock: @escaping CellBlock,
         value: Int,
         isEnabled: Bool = true) {
        self.title = title
        self.action = action
        self.scrollingBlock = scrollingBlock
        self.value = value
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension TimePickerItem: ItemProtocol {
    
    var identifier: String { TimePickerCell.identifier }
}
