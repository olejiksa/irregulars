//
//  Test.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum Test {
    
    enum Kind {
        case twoForms
        case translation
        case retranslation
        case listening
        case sentences
    }
    
    case translation
    case writing
    case sentences
    case listening
    
    var kinds: [Kind] {
        switch self {
        case .translation:
            return [.translation, .retranslation]
        case .writing:
            return [.twoForms]
        case .sentences:
            return [.sentences]
        case .listening:
            return [.listening]
        }
    }
    
    var title: String {
        switch self {
        case .translation:
            return "translation".localized
        case .writing:
            return "forms".localized
        case .sentences:
            return "sentences".localized
        case .listening:
            return "listening".localized
        }
    }
}
