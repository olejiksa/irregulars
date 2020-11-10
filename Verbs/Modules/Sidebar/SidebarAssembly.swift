//
//  SidebarAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarAssembly: AssemblyProtocol {
    
    typealias ViewController = SidebarViewController
    
    func viewController() -> ViewController {
        let presenter = SidebarPresenter()
        let viewController = SidebarViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}

