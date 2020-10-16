//
//  TranslationItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct TranslationItem {
    
    let header: String
    let text: String
}

// MARK: - ItemProtocol

extension TranslationItem: ItemProtocol {
    
    var identifier: String { TranslationCell.identifier }
}

// MARK: - SectionProtocol

extension TranslationItem: SectionProtocol {}
