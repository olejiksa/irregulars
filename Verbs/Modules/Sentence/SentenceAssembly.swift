//
//  SentenceAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SentenceAssembly: AssemblyProtocol {
    
    func viewController() -> some SentenceViewController {
        let presenter = SentencePresenter(verbsService: .init(),
                                          sentencesService: .init())
        let viewController = SentenceViewController(presenter: presenter)
        let router = TestDetailRouter(viewController: viewController)
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
}
