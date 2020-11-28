//
//  AccentColorAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class AccentColorAssembly: AssemblyProtocol {
    
    func viewController() -> some AccentColorViewController {
        let presenter = AccentColorPresenter()
        let viewConroller = AccentColorViewController(presenter: presenter)
        presenter.viewController = viewConroller
        return viewConroller
    }
}
