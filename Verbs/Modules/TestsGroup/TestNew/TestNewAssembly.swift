//
//  TestNewAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

final class TestNewAssembly {
    
    var viewController: UIHostingController<TestNewView> {
        let view = TestNewView()
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
