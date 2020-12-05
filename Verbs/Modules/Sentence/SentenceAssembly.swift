//
//  SentenceAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SentenceAssembly: AssemblyProtocol {
    
    func viewController() -> some SentenceViewController {
        let presenter = SentencePresenter()
        let viewController = SentenceViewController(presenter: presenter)
        return viewController
    }
}
