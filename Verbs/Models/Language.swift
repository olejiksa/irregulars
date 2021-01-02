//
//  Language.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum Language: String {
    
    case english = "en"
    case russian = "ru"
    case spanish = "es"
    
    var description: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        case .spanish:
            return "Español"
        }
    }
}
