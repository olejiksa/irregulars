//
//  RightDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class RightDetailItem {
    
    let title: String
    var subtitle: String
    let actionBlock: ItemBlock?
    let hasDisclosureItem: Bool
    let isEnabled: Bool
    
    init(title: String,
         subtitle: String,
         actionBlock: ItemBlock? = nil,
         hasDisclosureItem: Bool? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.hasDisclosureItem = hasDisclosureItem ?? (actionBlock != nil)
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension RightDetailItem: ItemProtocol {
    
    var identifier: String { RightDetailCell.identifier }
}

// MARK: - Actionable

extension RightDetailItem: Actionable {}
