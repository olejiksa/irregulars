//
//  Region.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

enum Region: String {
    
    case australia = "AU"
    case ireland = "IE"
    case india = "IN"
    case southAfrica = "ZA"
    case unitedKingdom = "GB"
    case unitedStates = "US"
    
    var description: String {
        switch self {
        case .australia:
            return "Australian".localized
        case .ireland:
            return "Irish".localized
        case .india:
            return "Indian".localized
        case .southAfrica:
            return "South African".localized
        case .unitedKingdom:
            return "British".localized
        case .unitedStates:
            return "American".localized
        }
    }
    
    static var current: Region {
        get {
            guard let string = UserDefaults.shared.string(for: .region),
                  let color = Region(rawValue: string) else { return .unitedStates }
            return color
        }
        set {
            UserDefaults.shared.set(newValue.rawValue, for: .region)
        }
    }
}
