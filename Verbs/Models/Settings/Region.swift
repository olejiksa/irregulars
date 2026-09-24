//
//  Region.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

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
            return String(localized: "australian")
        case .ireland:
            return String(localized: "irish")
        case .india:
            return String(localized: "indian")
        case .southAfrica:
            return String(localized: "south_african")
        case .unitedKingdom:
            return String(localized: "british")
        case .unitedStates:
            return String(localized: "american")
        }
    }
}
