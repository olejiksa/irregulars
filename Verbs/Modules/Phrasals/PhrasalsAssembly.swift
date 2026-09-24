//
//  PhrasalsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/12/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

@MainActor
final class PhrasalsAssembly {
    
    var viewController: UIHostingController<PhrasalsView> {
        let view = PhrasalsView()
        let viewController = UIHostingController(rootView: view)
        viewController.title = "phrasal_verbs".localized
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
