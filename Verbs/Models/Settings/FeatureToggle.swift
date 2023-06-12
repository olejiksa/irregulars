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
    static var isDebug = true
    static var arePhrasalsAvailable = true
    #else
    static var isDebug = false
    static var arePhrasalsAvailable = false
    #endif
    
    static var editionName: String { !isPaid ? "Lite" : "Pro" }
}
