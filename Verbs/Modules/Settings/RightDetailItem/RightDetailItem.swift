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
    let hasDisclosureIndicator: Bool
    let accessibilityIdentifier: AccessibilityIdentifier?
    let isEnabled: Bool
    
    init(title: String,
         subtitle: String,
         actionBlock: ItemBlock? = nil,
         hasDisclosureIndicator: Bool? = nil,
         accessibilityIdentifier: AccessibilityIdentifier? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.hasDisclosureIndicator = hasDisclosureIndicator ?? (actionBlock != nil)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension RightDetailItem: ItemProtocol {
    
    var identifier: String { RightDetailCell.identifier }
}

// MARK: - Actionable

extension RightDetailItem: Actionable {}
