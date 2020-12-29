//
//  SliderItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SliderItem {
    
    let leadingIcon: SystemIcon
    let leadingAccessibilityText: String
    let trailingIcon: SystemIcon
    let trailingAccessibilityText: String
    let steps: Int
    var index: Int
    let playbackSpeedBlock: IntBlock
    let isEnabled: Bool
    
    init(leadingIcon: SystemIcon,
         leadingAccessibilityText: String,
         trailingIcon: SystemIcon,
         trailingAccessibilityText: String,
         steps: Int,
         index: Int,
         playbackSpeedBlock: @escaping IntBlock,
         isEnabled: Bool) {
        self.leadingIcon = leadingIcon
        self.leadingAccessibilityText = leadingAccessibilityText
        self.trailingIcon = trailingIcon
        self.trailingAccessibilityText = trailingAccessibilityText
        self.steps = steps
        self.index = index
        self.playbackSpeedBlock = playbackSpeedBlock
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension SliderItem: ItemProtocol {
    
    var identifier: String { SliderCell.identifier }
}
