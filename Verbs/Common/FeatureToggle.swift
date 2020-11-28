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
            UserDefaults.standard.bool(for: .isPaid)
        }
        set {
            UserDefaults.standard.set(newValue, for: .isPaid)
            NotificationCenter.default.post(name: .paid, object: nil)
        }
    }
    
    static var isDebug = true
}
