//
//  AcknowledgementsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import SwiftUI

final class AcknowledgementsAssembly {
    
    var viewController: UIHostingController<AcknowledgementsView> {
        let view = AcknowledgementsView()
        let viewController = UIHostingController(rootView: view)
        viewController.title = String.localized(.acknowledgements)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
