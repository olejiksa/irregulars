//
//  TestListNewViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/23/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

final class TestListNewViewModel: ObservableObject {
    
    @Published var items: [TestItem]
    
    private let languageService = LanguageService()
    private let hapticService = HapticService()
    
    init() {
        let translationItem = languageService.hasTranslation
            ? TestItem(icon: .globe,
                       test: .translation,
                       accessibilityIdentifier: nil)
            : nil
        
        items = [translationItem,
                 TestItem(icon: .pencil,
                          test: .writing,
                          accessibilityIdentifier: .writingCell),
                 TestItem(icon: .sentences,
                          test: .sentences,
                          accessibilityIdentifier: .sentencesCell),
                 TestItem(icon: .headphones,
                          test: .listening,
                          accessibilityIdentifier: .listeningCell),
                 TestItem(icon: .mic,
                          test: .speaking),
                 TestItem(icon: .chart,
                          title: "statistics".localized,
                          subtitle: "track_your_progress_in_learning_irregular_verbs".localized,
                          accessibilityIdentifier: .statisticsCell)
        ].compactMap { $0 }
    }
}
