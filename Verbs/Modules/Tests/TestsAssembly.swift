//
//  TestsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsAssembly: AssemblyProtocol {
    
    typealias ViewController = TestsViewController
    
    func viewController() -> ViewController {
        let presenter = TestsPresenter()
        let viewConroller = TestsViewController(presenter: presenter)
        return viewConroller
    }
}
