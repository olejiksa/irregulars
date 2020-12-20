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
        case speaking
    }
    
    case translation
    case writing
    case sentences
    case listening
    case speaking
    
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
        case .speaking:
            return [.speaking]
        }
    }
    
    var title: String {
        switch self {
        case .translation:
            return "Translation".localized
        case .writing:
            return "Forms".localized
        case .sentences:
            return "Sentences".localized
        case .listening:
            return "Listening".localized
        case .speaking:
            return "Speaking".localized
        }
    }
}
