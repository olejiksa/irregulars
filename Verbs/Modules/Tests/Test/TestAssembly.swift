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
    private let catalogue: VerbCatalogue
    
    init(test: Test, catalogue: VerbCatalogue) {
        self.test = test
        self.catalogue = catalogue
    }
    
    func viewModel() -> TestSessionViewModel {
        let factory = TestQuestionFactory(catalogue: catalogue)
        return TestSessionViewModel(audioService: AudioService(voiceService: .init()),
                                             recordService: .init(),
                                             playerService: .init(),
                                             catalogue: catalogue,
                                             demoService: .init(),
                                             factory: factory,
                                    test: test)
    }
}
