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
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case chinese = "zh"
    
    var description: String {
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский"
        case .french:
            return "Français"
        case .german:
            return "Deutsch"
        case .spanish:
            return "Español"
        case .italian:
            return "Italiano"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .chinese:
            return "汉语"
        }
    }
}
