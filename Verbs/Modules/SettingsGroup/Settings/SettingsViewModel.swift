//
//  SettingsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

struct SettingsViewModel {
    
    private let languageService = LanguageService()
    private let mailService = MailService()
    
    let developerURL = URL(string: "itms-apps://apps.apple.com/developer/id1460125465")
    let webURL = URL(string: "https://apps.apple.com/app/id1540487254")
    
    var privacyPolicyURL: URL? {
        let code = languageService.legal.rawValue
        return URL(string: "https://github.com/olejiksa/legal/blob/master/privacy-\(code).md")
    }
    
    var termsURL: URL? {
        let code = languageService.legal.rawValue
        return URL(string: "https://github.com/olejiksa/legal/blob/master/terms-\(code).md")
    }
    
    private var rateURL: URL? {
        guard let productURL = URL(string: "itms-apps://apps.apple.com/app/id1540487254") else { return nil }
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
    
    var language: String {
        languageService.current.description
    }
    
    var canOpenMail: Bool {
        mailService.isMailAvailable
    }
    
    var canOpenAllApps: Bool {
        UIApplication.shared.canOpenURL(developerURL!)
    }
    
    var canOpenRateAndReview: Bool {
        UIApplication.shared.canOpenURL(rateURL!)
    }
    
    func openMail() {
        mailService.present()
    }
    
    func rateAndReview() {
        Task { @MainActor in
            guard let rateURL else { return }
            await UIApplication.shared.open(rateURL)
        }
    }
}
