//
//  PickableItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class PickableItem {
    
    let title: String
    var subtitle: String
    let actionBlock: ItemBlock?
    let hasDisclosureIndicator: Bool
    let options: [String]
    let isEnabled: Bool
    
    init(title: String,
         subtitle: String,
         actionBlock: ItemBlock? = nil,
         hasDisclosureIndicator: Bool? = nil,
         options: [String],
         isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.hasDisclosureIndicator = hasDisclosureIndicator ?? (actionBlock != nil)
        self.options = options
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension PickableItem: ItemProtocol {
    
    var identifier: String { PickableCell.identifier }
}

// MARK: - Actionable

extension PickableItem: Actionable {}
