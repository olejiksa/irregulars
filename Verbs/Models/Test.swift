//
//  Test.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum Test {
    
    enum Kind {
        case threeForms
        case translation
        case retranslation
        case listening
        case sentences
    }
    
    case basic
    case advanced
    
    var kinds: [Kind] {
        switch self {
        case .basic:
            return [.threeForms, .translation, .retranslation, .listening]
        case .advanced:
            return [.sentences]
        }
    }
    
    var title: String {
        switch self {
        case .basic:
            return "ThreeFormsTitle".localized
        case .advanced:
            return "SentenceTitle".localized
        }
    }
}
