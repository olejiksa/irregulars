//
//  DisclosureItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct DisclosureItem {
    
    let text: String
    let isEnabled: Bool
    let actionBlock: (() -> ())
}

// MARK: - ItemProtocol

extension DisclosureItem: ItemProtocol {
    
    var identifier: String { DisclosureCell.identifier }
}

// MARK: - Actionable

extension DisclosureItem: Actionable {}
