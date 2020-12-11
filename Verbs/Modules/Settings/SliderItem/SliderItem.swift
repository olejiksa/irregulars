//
//  SliderItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SliderItem {
    
    let leadingIcon: SystemIcon
    let trailingIcon: SystemIcon
    let steps: Int
    var index: Int
    let playbackSpeedBlock: IntBlock
    let isEnabled: Bool
    
    init(leadingIcon: SystemIcon,
         trailingIcon: SystemIcon,
         steps: Int,
         index: Int,
         playbackSpeedBlock: @escaping IntBlock,
         isEnabled: Bool) {
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
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
