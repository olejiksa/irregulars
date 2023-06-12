//
//  StepperItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class StepperItem {
    
    let title: String
    let minimum: Int
    let maximum: Int
    var value: Int
    let action: IntBlock
    
    init(title: String,
         minimum: Int,
         maximum: Int,
         value: Int,
         action: @escaping IntBlock) {
        self.title = title
        self.minimum = minimum
        self.maximum = maximum
        self.value = value
        self.action = action
    }
}

// MARK: - ItemProtocol

extension StepperItem: ItemProtocol {
    
    var identifier: String { StepperCell.identifier }
}
