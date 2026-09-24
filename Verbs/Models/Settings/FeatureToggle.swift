//
//  FeatureToggle.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import SwiftUI

struct FeatureToggle {
    
    /// Stored in the shared defaults, so the widget sees it too. Computed rather than
    /// held in a static, which Swift 6 will not allow across actors.
    static var isPaid: Bool {
        get { UserDefaults.shared.bool(for: .isPaid) }
        set {
            UserDefaults.shared.set(newValue, for: .isPaid)
            NotificationCenter.default.post(name: .reload, object: nil)
        }
    }
    
    #if DEBUG
    static let isDebug = false
    static let arePhrasalsAvailable = false
    #else
    static let isDebug = false
    static let arePhrasalsAvailable = false
    #endif
    
    static func isOnboardingAvailable(_ preferences: Preferences) -> Bool {
        #if DEBUG
        false
        #else
        !preferences.hasLaunchedBefore &&
        (LanguageService().current == .russian || LanguageService().current == .english)
        #endif
    }
    
    static var editionName: String { !isPaid ? "Lite" : "Pro" }
}
