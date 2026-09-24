//
//  TestAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestAssembly: AssemblyProtocol {
    
    private let test: Test
    
    init(test: Test) {
        self.test = test
    }
    
    func viewController() -> some TestViewController {
        let verbsService = VerbsService()
        let factory = TestQuestionFactory(languageService: .init(),
                                          sentencesService: .init(),
                                          verbsService: verbsService)
        let viewModel = TestSessionViewModel(audioService: AudioService(voiceService: .init()),
                                             recordService: .init(),
                                             playerService: .init(),
                                             verbsService: verbsService,
                                             favoritesService: Locator.favoritesService,
                                             demoService: .init(),
                                             factory: factory,
                                             test: test)
        
        return TestViewController(viewModel: viewModel, title: test.title)
    }
}
