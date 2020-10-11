//
//  LanguageService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class LanguageService {
    
    var hasTranslation: Bool {
        guard let currentLanguage = Locale.current.languageCode else { return false }
        let supportedLocalizations = Bundle.main.localizations
        let isLocalizedToCurrentLanguage = supportedLocalizations.contains(currentLanguage)
        let isCurrentLanguageEnglish = Language(rawValue: currentLanguage) == .some(.english)
        return isLocalizedToCurrentLanguage && !isCurrentLanguageEnglish
    }
}
