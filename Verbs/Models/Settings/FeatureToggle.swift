//
//  FeatureToggle.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct FeatureToggle {
    
    static var isPaid: Bool {
        get {
            UserDefaults.shared.bool(for: .isPaid)
        }
        set {
            UserDefaults.shared.set(newValue, for: .isPaid)
            NotificationCenter.default.post(name: .reload, object: nil)
        }
    }
    
    #if DEBUG
    static var isDebug = true
    #else
    static var isDebug = false
    #endif
    
    static var editionName: String { !isPaid ? "Lite" : "Pro" }
}
