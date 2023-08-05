//
//  AccentColor.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import SwiftUI

enum AccentColor: String, CaseIterable {
    
    case red
    case green
    case blue
    case orange
    case yellow
    case pink
    case purple
    case teal
    case indigo
    case brown
    case mint
    case cyan
    
    static var current: AccentColor {
        get {
            guard let string = UserDefaults.shared.string(for: .accentColor),
                  let color = AccentColor(rawValue: string) else { return .blue }
            return color
        }
        set {
            UserDefaults.shared.set(newValue.rawValue, for: .accentColor)
            NotificationCenter.default.post(name: .reload, object: nil)
            let scene = UIApplication.shared.connectedScenes.first
            let sd = scene?.delegate as? SceneDelegate
            sd?.window?.tintColor = newValue.color
        }
    }
    
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
        case .brown: return .systemBrown
        case .mint: return .systemMint
        case .cyan: return .systemCyan
        }
    }
    
    var colorSwiftUI: Color {
        Color(uiColor: color)
    }
}
