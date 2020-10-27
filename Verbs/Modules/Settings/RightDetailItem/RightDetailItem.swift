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
    let subitems: [String]?
    let isEnabled: Bool
    
    init(title: String,
         subtitle: String,
         actionBlock: ((ItemProtocol) -> ())? = nil,
         subitems: [String]? = nil,
         isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.subitems = subitems
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension RightDetailItem: ItemProtocol {
    
    var identifier: String { RightDetailCell.identifier }
}
