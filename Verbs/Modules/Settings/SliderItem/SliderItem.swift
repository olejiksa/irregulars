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
    let playbackSpeedBlock: IntBlock
    let isEnabled: Bool
    
    var index: Int {
        didSet {
            switch oldValue {
            case (0..<steps):
                self.index = oldValue
            case (..<0):
                self.index = 0
            case (steps...):
                self.index = steps
            default:
                self.index = 0
            }
        }
    }
    
    init(leadingIcon: SystemIcon,
         trailingIcon: SystemIcon,
         steps: Int,
         index: Int,
         playbackSpeedBlock: @escaping IntBlock,
         isEnabled: Bool) {
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.steps = steps >= 0 ? steps : 0
        self.index = index
        self.playbackSpeedBlock = playbackSpeedBlock
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension SliderItem: ItemProtocol {
    
    var identifier: String { SliderCell.identifier }
}
