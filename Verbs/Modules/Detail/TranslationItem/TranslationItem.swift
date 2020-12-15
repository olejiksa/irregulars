//
//  TranslationItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct TranslationItem {
    
    let text: String
    let isTrulyTranslation: Bool
    
    init(text: String, isTrulyTranslation: Bool = true) {
        self.text = text
        self.isTrulyTranslation = isTrulyTranslation
    }
}

// MARK: - ItemProtocol

extension TranslationItem: ItemProtocol {
    
    var identifier: String { TranslationCell.identifier }
}
