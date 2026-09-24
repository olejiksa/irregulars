//
//  ListViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class ListViewModel {
    
    struct VerbSection: Identifiable {
        let id: Int
        let header: String
        let verbs: [Verb]
    }
    
    private(set) var sections: [VerbSection] = []
    private(set) var searchResults: [Verb] = []
    private(set) var state: ListState = .data
    var showsTranslation = false
    private(set) var showsSectionIndex = true
    private(set) var scrollToTopToken = 0
    
    var isSearchActive = false
    var searchText = "" {
        didSet {
            guard searchText != oldValue else { return }
            updateSearch(text: searchText)
        }
    }
    var isEditing = false
    var selectedVerb: Verb?
    var isShowingPaywall = false
    
    let favoritesOnly: Bool
    let hasTranslation: Bool
    
    /// Set by the view controller, which owns the navigation.
    var onSelect: ((Verb) -> Void)?
    
    private let catalogue: VerbCatalogue
    private let preferences: Preferences
    private let favorites: Favorites
    private let printService: PrintService
    private var cancellables = Set<AnyCancellable>()
    
    /// The filters this list applies, kept here rather than inside a shared service:
    /// the tests screen has its own pair and they must not merge.
    private var showsRegulars = true
    private var showsDerivatives = true
    private var groupsBySimilarity = false
    
    init(favoritesOnly: Bool,
         catalogue: VerbCatalogue,
         preferences: Preferences,
         favorites: Favorites,
         languageService: LanguageService = .init(),
         printService: PrintService = .init()) {
        self.favoritesOnly = favoritesOnly
        self.catalogue = catalogue
        self.preferences = preferences
        self.favorites = favorites
        self.printService = printService
        
        hasTranslation = languageService.hasTranslation
        
        loadSettings()
        subscribe()
        rebuild()
    }
    
    // MARK: Selection
    
    func select(_ verb: Verb?) {
        selectedVerb = verb
        
        guard let verb else { return }
        
        onSelect?(verb)
    }
    
    // MARK: Search
    
    func updateSearch(text: String) {
        rebuild()
    }
    
    func setSearchActive(_ isActive: Bool) {
        isSearchActive = isActive
        rebuild()
    }
    
    // MARK: Menu
    
    func updateRegulars(_ value: Bool) {
        showsRegulars = value
        rebuild()
    }
    
    func updateDerivatives(_ value: Bool) {
        showsDerivatives = value
        rebuild()
    }
    
    func print() {
        printService.print(verbs, hasTranslation: hasTranslation)
    }
    
    // MARK: Favorites
    
    func toggleFavorite(_ verb: Verb) {
        if favorites.verbs.contains(verb) {
            favorites.remove(verb)
        } else {
            guard !favorites.shouldPaywallBeShown else {
                isShowingPaywall = true
                return
            }
            
            favorites.add(verb)
        }
    }
    
    func remove(_ verb: Verb) {
        favorites.remove(verb)
    }
    
    func isFavorite(_ verb: Verb) -> Bool {
        favorites.verbs.contains(verb)
    }
    
    func canDrag(_ verb: Verb) -> Bool {
        !favoritesOnly && !isSearchActive && !isFavorite(verb)
    }
    
    func scrollToTop() {
        scrollToTopToken += 1
    }
    
    // MARK: Menu
    
    var showsTranslationBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.showsTranslation ?? false },
              set: { [weak self] value in
                  self?.preferences.showsTranslation = value
                  self?.showsTranslation = value && (self?.hasTranslation ?? false)
                  self?.rebuild()
              })
    }
    
    var groupsBySimilarityBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.groupsBySimilarity ?? false },
              set: { [weak self] value in
                  self?.preferences.groupsBySimilarity = value
                  self?.groupsBySimilarity = value
                  self?.rebuild()
              })
    }
    
    var showsRegularsBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.showsRegulars ?? false },
              set: { [weak self] value in
                  self?.preferences.showsRegularVerbs = value
                  self?.updateRegulars(value)
              })
    }
    
    var showsDerivativesBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.showsDerivatives ?? false },
              set: { [weak self] value in
                  self?.preferences.showsDerivatives = value
                  self?.updateDerivatives(value)
              })
    }
    
    /// Set by the container: the all-verbs list is called "verbs" next to a tab bar
    /// and "all" next to the sidebar.
    var title = ""
    
    func clearSelection() {
        selectedVerb = nil
    }
    
}

// MARK: - Private

extension ListViewModel {
    
    fileprivate func loadSettings() {
        showsRegulars = preferences.showsRegularVerbs
        showsDerivatives = preferences.showsDerivatives
        showsTranslation = preferences.showsTranslation && hasTranslation
        groupsBySimilarity = preferences.groupsBySimilarity
    }
    
    /// The verbs this list shows, before searching.
    var verbs: [Verb] {
        catalogue.verbs(favoritesOnly: favoritesOnly,
                        includingRegular: showsRegulars,
                        includingDerived: showsDerivatives)
    }
    
    func subscribe() {
        let center = NotificationCenter.default
        
        
        
        
        center.publisher(for: .favorites)
            .sink { [weak self] _ in self?.rebuild() }
            .store(in: &cancellables)
        
        center.publisher(for: .reload)
            .sink { [weak self] _ in self?.rebuild() }
            .store(in: &cancellables)
    }
    
    func rebuild() {
        showsSectionIndex = !isSearchActive && !groupsBySimilarity
        
        let verbs = verbs
        let grouping = catalogue.grouped(verbs, bySimilarity: groupsBySimilarity)
        sections = zip(grouping.headers.indices, grouping.headers).map { index, header in
            VerbSection(id: index, header: header, verbs: grouping.groups[safe: index] ?? [])
        }
        
        searchResults = catalogue.search(searchText, in: verbs)
        
        let shown = isSearchActive ? searchResults : verbs
        state = ListState(isSearchActive: isSearchActive,
                          isSearchTextEmpty: searchText.isEmpty,
                          areItemsEmpty: shown.isEmpty)
    }
}
