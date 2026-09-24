//
//  TestsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class TestsViewModel {
    
    struct Row: Identifiable {
        let id: String
        let icon: SystemIcon
        let title: String
        let subtitle: String
        /// Nil leads to the statistics screen rather than to a test.
        let test: Test?
        let accessibilityIdentifier: AccessibilityIdentifier?
    }
    
    private(set) var rows: [Row] = []
    private(set) var scrollToTopToken = 0
    
    /// Bumped to ask the view for a haptic tap.
    private(set) var errorFeedback = 0
    
    /// Set by the view controller, which owns the navigation.
    var onSelect: ((Test?) -> Void)?
    var onEmptyFavorites: (() -> Void)?
    var onPaywall: (() -> Void)?
    
    private let languageService: LanguageService
    private var cancellables = Set<AnyCancellable>()
    private let preferences: Preferences
    private let favorites: Favorites
    
    
    init(languageService: LanguageService = .init(),
         preferences: Preferences,
         favorites: Favorites) {
        self.preferences = preferences
        self.favorites = favorites
        self.languageService = languageService
        
        build()
        subscribe()
        refreshFilter()
    }
    
    func select(_ row: Row) {
        if row.test != nil,
           preferences.testsUseFavoritesOnly,
           favorites.verbs.isEmpty {
            errorFeedback += 1
            onEmptyFavorites?()
            return
        }
        
        onSelect?(row.test)
    }
    
    func scrollToTop() {
        scrollToTopToken += 1
    }
    
    // MARK: Filter
    
    enum Scope: Hashable {
        case demo, all, favorites
    }
    
    /// Mirrored into real state: observation cannot see through a computed property
    /// that reads the defaults.
    private(set) var isPaid = FeatureToggle.isPaid
    private(set) var favoritesOnly = false
    private(set) var showsRegulars = true
    private(set) var showsDerivatives = true
    
    var isFiltered: Bool { favoritesOnly || !showsRegulars || !showsDerivatives }
    
    var scope: Scope {
        guard isPaid else { return .demo }
        return favoritesOnly ? .favorites : .all
    }
    
    var scopeBinding: Binding<Scope> {
        .init(get: { [weak self] in self?.scope ?? .demo },
              set: { [weak self] scope in
                  guard let self else { return }
                  guard isPaid else {
                      onPaywall?()
                      return
                  }
                  
                  preferences.testsUseFavoritesOnly = scope == .favorites
                  refreshFilter()
              })
    }
    
    var showsRegularsBinding: Binding<Bool> { toggle(for: .regularVerbsTests) }
    var showsDerivativesBinding: Binding<Bool> { toggle(for: .derivativesTests) }
    
    private func toggle(for key: UserDefaults.Key) -> Binding<Bool> {
        .init(get: { key == .regularVerbsTests ? self.showsRegulars : self.showsDerivatives },
              set: { [weak self] value in
                  guard let self else { return }
                  guard isPaid else {
                      onPaywall?()
                      return
                  }
                  
                  if key == .regularVerbsTests {
                      preferences.testsIncludeRegularVerbs = value
                  } else {
                      preferences.testsIncludeDerivatives = value
                  }
                  
                  refreshFilter()
              })
    }
    
    func refreshFilter() {
        isPaid = FeatureToggle.isPaid
        favoritesOnly = preferences.testsUseFavoritesOnly
        showsRegulars = preferences.testsIncludeRegularVerbs
        showsDerivatives = preferences.testsIncludeDerivatives
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
        
        NotificationCenter.default.publisher(for: .reload)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refreshFilter() }
            .store(in: &cancellables)
    }
}
