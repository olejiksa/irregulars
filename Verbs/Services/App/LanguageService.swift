//
//  LanguageService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class LanguageService {
    
    var current: Language {
        guard let currentLanguage = Locale.current.languageCode else { return .english }
        return Language(rawValue: currentLanguage) ?? .english
    }
    
    var legal: Language {
        switch current {
        case .russian:
            return .russian
        default:
            return .english
        }
    }
    
    var hasTranslation: Bool {
        guard let currentLanguage = Locale.current.languageCode else { return false }
        let supportedLocalizations = Bundle.main.localizations
        let isLocalizedToCurrentLanguage = supportedLocalizations.contains { $0.contains(currentLanguage) }
        let isCurrentLanguageEnglish = Language(rawValue: currentLanguage) == .english
        return isLocalizedToCurrentLanguage && !isCurrentLanguageEnglish
    }
}
