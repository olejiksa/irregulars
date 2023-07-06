//
//  FeatureToggle.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

struct FeatureToggle {
    
    static var isPaid: Bool {
        get {
            UserDefaults.shared.bool(for: .isPaid)
        }
        set {
            UserDefaults.shared.set(newValue, for: .isPaid)
            NotificationCenter.default.post(name: .reload, object: nil)
            UIMenuSystem.main.setNeedsRebuild()
        }
    }
    
    #if DEBUG
    static var isDebug = false
    static var arePhrasalsAvailable = false
    static var areNewTestsAvailable = false
    static var isNewTestListAvailable = false
    static var areNewSettingsAvailable = false
    #else
    static var isDebug = false
    static var arePhrasalsAvailable = false
    static var areNewTestsAvailable = false
    static var isNewTestListAvailable = false
    static var areNewSettingsAvailable = false
    #endif
    
    static var isOnboardingAvailable: Bool {
        #if DEBUG
        false
        #else
        !UserDefaults.shared.bool(for: .hasLaunchedBefore) &&
        (LanguageService().current == .russian || LanguageService().current == .english)
        #endif
    }
    
    static var editionName: String { !isPaid ? "Lite" : "Pro" }
}
