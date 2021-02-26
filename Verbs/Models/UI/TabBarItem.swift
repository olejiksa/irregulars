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
        case (_, is SettingsViewController),
             (_, is SettingsChildViewControllerProtocol):
            self = .settings
        case (let vc as ListViewController, _):
            self = vc.favoritesOnly ? .favorites : .all
        case (is TestsViewController, _):
            self = .tests
        default:
            return nil
        }
    }
}
