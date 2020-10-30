//
//  RightDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

class RightDetailItem {
    
    let title: String
    var subtitle: String
    let actionBlock: ((ItemProtocol) -> ())?
    let hasDisclosureItem: Bool
    let subitems: [String]?
    let isEnabled: Bool
    
    init(title: String,
         subtitle: String,
         actionBlock: ((ItemProtocol) -> ())? = nil,
         hasDisclosureItem: Bool? = nil,
         subitems: [String]? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.hasDisclosureItem = hasDisclosureItem ?? (actionBlock != nil)
        self.subitems = subitems
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension RightDetailItem: ItemProtocol {
    
    var identifier: String { RightDetailCell.identifier }
}
