//
//  TestAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

@MainActor
final class TestAssembly {
    
    private let test: Test
    
    init(test: Test) {
        self.test = test
    }
    
    func viewModel() -> TestSessionViewModel {
        let verbsService = VerbsService()
        let factory = TestQuestionFactory(languageService: .init(),
                                          sentencesService: .init(),
                                          verbsService: verbsService)
        return TestSessionViewModel(audioService: AudioService(voiceService: .init()),
                                             recordService: .init(),
                                             playerService: .init(),
                                             verbsService: verbsService,
                                             favoritesService: Locator.favoritesService,
                                             demoService: .init(),
                                             factory: factory,
                                    test: test)
    }
}
