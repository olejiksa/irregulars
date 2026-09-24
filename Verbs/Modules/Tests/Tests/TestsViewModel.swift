//
//  TestsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class TestsViewModel: ObservableObject {
    
    struct Row: Identifiable {
        let id: String
        let icon: SystemIcon
        let title: String
        let subtitle: String
        /// Nil leads to the statistics screen rather than to a test.
        let test: Test?
        let accessibilityIdentifier: AccessibilityIdentifier?
    }
    
    @Published private(set) var rows: [Row] = []
    @Published private(set) var scrollToTopToken = 0
    
    /// Set by the view controller, which owns the navigation.
    var onSelect: ((Test?) -> Void)?
    var onEmptyFavorites: (() -> Void)?
    
    private let languageService: LanguageService
    private let hapticService: HapticService
    private var cancellables = Set<AnyCancellable>()
    
    /// The row already open in the detail column, so it is not pushed twice.
    private var selectedID: String?
    
    init(languageService: LanguageService, hapticService: HapticService) {
        self.languageService = languageService
        self.hapticService = hapticService
        
        build()
        subscribe()
    }
    
    func select(_ row: Row) {
        if row.test != nil,
           UserDefaults.shared.bool(for: .favoritesOnly),
           Locator.favorites.verbs.isEmpty {
            hapticService.generateHapticFeedback(for: .notification(.error))
            onEmptyFavorites?()
            return
        }
        
        guard row.id != selectedID else { return }
        
        selectedID = row.id
        onSelect?(row.test)
    }
    
    func scrollToTop() {
        scrollToTopToken += 1
    }
}

// MARK: - Private

private extension TestsViewModel {
    
    func build() {
        let tests: [(Test, SystemIcon, AccessibilityIdentifier?)] = [
            (.translation, .globe, nil),
            (.writing, .pencil, .writingCell),
            (.sentences, .sentences, .sentencesCell),
            (.listening, .headphones, .listeningCell),
            (.speaking, .mic, nil)
        ]
        
        rows = tests
            .filter { $0.0 != .translation || languageService.hasTranslation }
            .map { test, icon, identifier in
                Row(id: icon.rawValue,
                    icon: icon,
                    title: test.title,
                    subtitle: test.subtitle,
                    test: test,
                    accessibilityIdentifier: identifier)
            }
        
        rows.append(Row(id: SystemIcon.chart.rawValue,
                        icon: .chart,
                        title: "statistics".localized,
                        subtitle: "track_your_progress_in_learning_irregular_verbs".localized,
                        test: nil,
                        accessibilityIdentifier: .statisticsCell))
    }
    
    func subscribe() {
        NotificationCenter.default.publisher(for: .test)
            .sink { [weak self] _ in self?.selectedID = nil }
            .store(in: &cancellables)
    }
}
