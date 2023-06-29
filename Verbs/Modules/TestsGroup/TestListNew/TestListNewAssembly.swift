//
//  TestListNewAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/23/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

final class TestListNewAssembly {
    
    var viewController: UIHostingController<TestListNewView> {
        let view = TestListNewView()
        let viewController = UIHostingController(rootView: view)
        return viewController
    }
}
