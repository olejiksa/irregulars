//
//  TabBarItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

enum TabBarItem: Int {
    case all
    case favorites
    case tests
    case settings
    
    init?(supplementary: UIViewController, secondary: UIViewController) {
        switch (supplementary, secondary) {
        case (_, is SettingsViewController):
            self = .settings
        case (_, is AccentColorViewController):
            self = .settings
        case (is ListViewController, _):
            self = .all
        case (is FavoritesViewController, _):
            self = .favorites
        case (is TestsViewController, _):
            self = .tests
        default:
            return nil
        }
    }
}
