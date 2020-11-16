//
//  TestsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsAssembly: AssemblyProtocol {
    
    func viewController() -> some TestsViewController {
        let presenter = TestsPresenter()
        let viewConroller = TestsViewController(presenter: presenter)
        presenter.viewController = viewConroller
        _ = UINavigationController(rootViewController: viewConroller)
        return viewConroller
    }
}
