//
//  PopoverAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PopoverAssembly: AssemblyProtocol {
    
    private let width: CGFloat
    private let isCollapsed: Bool
    
    init(width: CGFloat, isCollapsed: Bool) {
        self.width = width
        self.isCollapsed = isCollapsed
    }
    
    func viewController() -> some PopoverViewController {
        let presenter = PopoverPresenter()
        let viewController = PopoverViewController(presenter: presenter,
                                                   width: width,
                                                   isCollapsed: isCollapsed)
        presenter.viewController = viewController
        return viewController
    }
}

