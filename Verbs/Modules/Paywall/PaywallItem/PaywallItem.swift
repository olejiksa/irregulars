//
//  PaywallItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct PaywallItem {
    
    let text: String
    let icon: SystemIcon
}

// MARK: - ItemProtocol

extension PaywallItem: ItemProtocol {
    
    var identifier: String { PaywallCell.identifier }
}
