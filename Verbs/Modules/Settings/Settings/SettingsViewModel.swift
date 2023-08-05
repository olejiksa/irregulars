//
//  SettingsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

final class SettingsViewModel: ObservableObject {
    
    init() {
        updateNotificationsAvailability()
    }
    
    // MARK: Services
    
    private let languageService = LanguageService()
    private let mailService = MailService()
    private let notificationService = NotificationService(verbsService: .init(), calendarService: .init())
    
    // MARK: Published
    
    @Published var notificationsAvailability: NotificationsAvailability = .notAllowed
    @Published var accentColor: AccentColor = .current
    @Published var voice: Voice? = .current
    @Published var isShowingPaywall = false
    @Published var isShowingFAQ = false
    
    // MARK: Links
    
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
    
    // MARK: Properties
    
    var edition: String {
        "\(Bundle.main.productName ?? "") \(FeatureToggle.editionName)"
    }
    
    var version: String {
        Bundle.main.releaseVersionNumber ?? ""
    }
    
    var language: String {
        languageService.current.description
    }
    
    // MARK: - Can open
    
    var canOpenMail: Bool {
        mailService.isMailAvailable
    }
    
    var canOpenAllApps: Bool {
        UIApplication.shared.canOpenURL(developerURL!)
    }
    
    var canOpenRateAndReview: Bool {
        UIApplication.shared.canOpenURL(rateURL!)
    }
    
    // MARK: - Methods
    
    func openMail() {
        mailService.present()
    }
    
    func rateAndReview() {
        Task { @MainActor in
            guard let rateURL else { return }
            await UIApplication.shared.open(rateURL)
        }
    }
    
    func updateNotificationsAvailability() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let result = await self.notificationService.isAvailable
            
            if result {
                self.notificationsAvailability = UserDefaults.shared.bool(for: .notifications) ? .enabled : .disabled
            } else {
                self.notificationsAvailability = .notAllowed
            }
        }
    }
}
