//
//  AcknowledgementsAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

final class AcknowledgementsAssembly: AssemblyProtocol {
    
    func viewController() -> some AcknowledgementsViewController {
        let presenter = AcknowledgementsPresenter()
        let viewConroller = AcknowledgementsViewController(presenter: presenter)
        presenter.viewController = viewConroller
        return viewConroller
    }
}
