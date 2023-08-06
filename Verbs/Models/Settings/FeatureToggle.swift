//
//  FeatureToggle.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct FeatureToggle {
    
    @AppStorage(UserDefaults.Key.isPaid.rawValue, store: UserDefaults.shared)
    static var isPaid: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .reload, object: nil)
            UIMenuSystem.main.setNeedsRebuild()
        }
    }
    
    #if DEBUG
    static var isDebug = false
    static var arePhrasalsAvailable = false
    #else
    static var isDebug = false
    static var arePhrasalsAvailable = false
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
