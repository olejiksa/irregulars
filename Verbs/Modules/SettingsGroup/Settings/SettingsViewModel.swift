//
//  SettingsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

struct SettingsViewModel {
    
    private let languageService = LanguageService()
    
    private let appStoreURL = URL(string: "itms-apps://apps.apple.com/app/id1540487254")
    
    let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")
    
    var privacyPolicyURL: URL? {
        let code = languageService.legal.rawValue
        return URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
    }
    
    var termsURL: URL? {
        let code = languageService.legal.rawValue
        return URL(string: "https://github.com/olejiksa/legal/blob/master/terms-\(code).md")
    }
    
    var rateURL: URL? {
        guard let productURL = appStoreURL else { return nil }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        return components?.url
    }
    
    var edition: String {
        "\(Bundle.main.productName ?? "") \(FeatureToggle.editionName)"
    }
    
    var version: String {
        Bundle.main.releaseVersionNumber ?? ""
    }
}
