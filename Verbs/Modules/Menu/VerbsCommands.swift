//
//  VerbsCommands.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import SwiftUI

/// The menu bar, which the Mac shows and the iPad reveals when a keyboard is attached.
struct VerbsCommands: Commands {
    
    @Environment(\.openURL) private var openURL
    
    /// Read through AppStorage so the menu rebuilds itself once the purchase lands.
    @AppStorage(UserDefaults.Key.isPaid.rawValue, store: UserDefaults.shared)
    private var isPaid = false
    
    private let router: AppRouter
    private let languageService = LanguageService()
    
    init(router: AppRouter) {
        self.router = router
    }
    
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("voice") { router.menuScreen = .voice }
            Button("notifications") { router.menuScreen = .notifications }
            
            Divider()
            
            if isPaid {
                if FeatureToggle.isDebug {
                    Button("downgrade_to") { FeatureToggle.isPaid = false }
                }
            } else {
                Button(String(localized: "upgrade_to_pro") + "…") { router.menuScreen = .paywall }
            }
        }
        
        CommandGroup(replacing: .printItem) {
            Button(String(localized: "print") + "…") { router.requestPrint() }
                .keyboardShortcut("p")
        }
        
        CommandGroup(replacing: .help) {
            Button("privacy_policy") { open(legalURL(named: "privacy")) }
            Button("terms") { open(legalURL(named: "terms")) }
            
            if let mailURL {
                Button("contact_us") { openURL(mailURL) }
            }
            
            Divider()
            
            Button(String(localized: "rate_and_review") + "…") { open(reviewURL) }
            
            if let webURL {
                ShareLink(item: webURL) {
                    Text(String(localized: "share_app") + "…")
                }
            }
        }
    }
}

// MARK: - Private

private extension VerbsCommands {
    
    var webURL: URL? { URL(string: "https://apps.apple.com/app/id1540487254") }
    
    var reviewURL: URL? {
        guard let productURL = URL(string: "itms-apps://apps.apple.com/app/id1540487254") else { return nil }
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        return components?.url
    }
    
    var mailURL: URL? {
        guard let productName = Bundle.main.productName,
              let version = Bundle.main.releaseVersionNumber else { return nil }
        
        var components = URLComponents(string: "mailto:quillaur@outlook.com")
        components?.queryItems = [URLQueryItem(name: "subject", value: "\(productName) \(version)")]
        return components?.url
    }
    
    func legalURL(named name: String) -> URL? {
        URL(string: "https://github.com/olejiksa/legal/blob/master/\(name)-\(languageService.legal.rawValue).md")
    }
    
    func open(_ url: URL?) {
        guard let url else { return }
        
        openURL(url)
    }
}
