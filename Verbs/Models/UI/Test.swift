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
            return String(localized: "translation")
        case .writing:
            return String(localized: "forms")
        case .sentences:
            return String(localized: "sentences")
        case .listening:
            return String(localized: "listening")
        case .speaking:
            return String(localized: "speaking")
        }
    }
    
    var subtitle: String {
        switch self {
        case .translation:
            return "translation_subtitle".localized
        case .writing:
            return "writing_subtitle".localized
        case .sentences:
            return "sentences_subtitle".localized
        case .listening:
            return "listening_subtitle".localized
        case .speaking:
            return "speaking_subtitle".localized
        }
    }
}
