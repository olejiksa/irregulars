//
//  SidebarDestination.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation

enum SidebarDestination: Int, CaseIterable, Identifiable {
    
    case all
    case favorites
    case tests
    case settings
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .all:
            return "all".localized
        case .favorites:
            return "favorites".localized
        case .tests:
            return "tests".localized
        case .settings:
            return "settings".localized
        }
    }
    
    var icon: SystemIcon {
        switch self {
        case .all:
            return .book
        case .favorites:
            return .star
        case .tests:
            return .puzzle
        case .settings:
            return .gear
        }
    }
    
    var accessibilityIdentifier: AccessibilityIdentifier {
        switch self {
        case .all:
            return .verbsTab
        case .favorites:
            return .favoritesTab
        case .tests:
            return .testsTab
        case .settings:
            return .settingsTab
        }
    }
    
    /// Everything but settings, which the Mac keeps in its own menu.
    static let verbs: [SidebarDestination] = [.all, .favorites, .tests]

}
