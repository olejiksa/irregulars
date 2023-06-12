//
//  AccentColorAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI

final class AccentColorAssembly {
    
    var viewController: UIHostingController<AccentColorView> {
        let view = AccentColorView()
        let viewController = UIHostingController(rootView: view)
        viewController.title = String.localized(.accentColor)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
