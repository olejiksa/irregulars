//
//  AccentColor.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

enum AccentColor: String, CaseIterable {
    case blue
    case green
    case indigo
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
    
    var color: UIColor {
        switch self {
        case .blue: return .systemBlue
        case .green: return .systemGreen
        case .indigo: return .systemIndigo
        case .orange: return .systemOrange
        case .pink: return .systemPink
        case .purple: return .systemPurple
        case .red: return .systemRed
        case .teal: return .systemTeal
        case .yellow: return .systemYellow
        }
    }
}
