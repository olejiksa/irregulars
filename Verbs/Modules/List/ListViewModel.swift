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
final class ListViewModel: ObservableObject {
    
    struct VerbSection: Identifiable {
        let id: Int
        let header: String
        let verbs: [Verb]
    }
    
    @Published private(set) var sections: [VerbSection] = []
    @Published private(set) var searchResults: [Verb] = []
    @Published private(set) var state: ListState = .data
    @Published private(set) var showsTranslation = false
    @Published private(set) var showsSectionIndex = true
    @Published private(set) var scrollToTopToken = 0
    
    @Published var isSearchActive = false
    @Published var searchText = "" {
        didSet {
            guard searchText != oldValue else { return }
            updateSearch(text: searchText)
        }
    }
    @Published var isEditing = false
    @Published var selectedVerb: Verb?
    @Published var isShowingPaywall = false
    
    let favoritesOnly: Bool
    let hasTranslation: Bool
    
    /// Set by the view controller, which owns the navigation.
    var onSelect: ((Verb) -> Void)?
    
    private let languageService: LanguageService
    private let verbsService: VerbsServiceProtocol
    private let printService: PrintService
    private var cancellables = Set<AnyCancellable>()
    
    /// The verb the detail column is showing, so tapping it again does not push a second time.
    private var openedInfinitive: String?
    
    init(languageService: LanguageService,
         verbsService: VerbsServiceProtocol,
         printService: PrintService) {
        self.languageService = languageService
        self.verbsService = verbsService
        self.printService = printService
        
        favoritesOnly = verbsService.favoritesOnly
        hasTranslation = languageService.hasTranslation
        
        loadSettings()
        subscribe()
        rebuild()
    }
    
    // MARK: Selection
    
    func select(_ verb: Verb?) {
        selectedVerb = verb
        
        guard let verb = verb, verb.infinitive.value != openedInfinitive else { return }
        
        onSelect?(verb)
    }
    
    // MARK: Search
    
    func updateSearch(text: String) {
        verbsService.searchText = text
        rebuild()
    }
    
    func setSearchActive(_ isActive: Bool) {
        isSearchActive = isActive
        rebuild()
    }
    
    // MARK: Menu
    
    func updateRegulars(_ value: Bool) {
        verbsService.shouldRegularVerbsBeShown = value
        rebuild()
    }
    
    func updateDerivatives(_ value: Bool) {
        verbsService.shouldDerivativesBeShown = value
        rebuild()
    }
    
    func print() {
        printService.print(verbsService.items, hasTranslation: hasTranslation)
    }
    
    // MARK: Favorites
    
    func toggleFavorite(_ verb: Verb) {
        if Locator.favorites.verbs.contains(verb) {
            Locator.favorites.remove(verb)
        } else {
            guard !Locator.favorites.shouldPaywallBeShown else {
                isShowingPaywall = true
                return
            }
            
            Locator.favorites.add(verb)
        }
    }
    
    func remove(_ verb: Verb) {
        Locator.favorites.remove(verb)
    }
    
    func isFavorite(_ verb: Verb) -> Bool {
        Locator.favorites.verbs.contains(verb)
    }
    
    func canDrag(_ verb: Verb) -> Bool {
        !favoritesOnly && !isSearchActive && !isFavorite(verb)
    }
    
    func scrollToTop() {
        scrollToTopToken += 1
    }
    
    // MARK: Menu
    
    var showsTranslationBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.verbsService.shouldTranslationBeShown ?? false },
              set: { [weak self] value in
                  UserDefaults.shared.set(value, for: .shouldTranslationBeShown)
                  self?.verbsService.shouldTranslationBeShown = value
                  self?.rebuild()
              })
    }
    
    var groupsBySimilarityBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.verbsService.shouldSimilarBeShown ?? false },
              set: { [weak self] value in
                  UserDefaults.shared.set(value, for: .shouldSimilarBeShown)
                  self?.verbsService.shouldSimilarBeShown = value
                  self?.rebuild()
              })
    }
    
    var showsRegularsBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.verbsService.shouldRegularVerbsBeShown ?? false },
              set: { [weak self] value in
                  UserDefaults.shared.set(value, for: .regularVerbs)
                  self?.updateRegulars(value)
              })
    }
    
    var showsDerivativesBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.verbsService.shouldDerivativesBeShown ?? false },
              set: { [weak self] value in
                  UserDefaults.shared.set(value, for: .derivatives)
                  self?.updateDerivatives(value)
              })
    }
    
    var title: String {
        favoritesOnly ? "favorites".localized : "all".localized
    }
    
    /// Highlights the verb the detail column is showing, without pushing it again.
    func setOpenedVerb(_ infinitive: String) {
        openedInfinitive = infinitive.isEmpty ? nil : infinitive
        selectedVerb = verbsService.items.first { $0.infinitive.value == infinitive }
    }
}

// MARK: - Private

extension ListViewModel {
    
    fileprivate func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        verbsService.shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
        verbsService.shouldSimilarBeShown = UserDefaults.shared.bool(for: .shouldSimilarBeShown)
    }
    
    func subscribe() {
        let center = NotificationCenter.default
        
        center.publisher(for: .infinitive)
            .sink { [weak self] notification in
                let infinitive = notification.userInfo?[Notification.Name.infinitive] as? String ?? ""
                self?.setOpenedVerb(infinitive)
            }
            .store(in: &cancellables)
        
        center.publisher(for: .listView)
            .sink { [weak self] notification in
                let value = notification.userInfo?[Notification.Name.listView] as? Bool ?? false
                self?.verbsService.shouldTranslationBeShown = value
                self?.rebuild()
            }
            .store(in: &cancellables)
        
        center.publisher(for: .grouping)
            .sink { [weak self] notification in
                let value = notification.userInfo?[Notification.Name.grouping] as? Bool ?? false
                self?.verbsService.shouldSimilarBeShown = value
                self?.rebuild()
            }
            .store(in: &cancellables)
        
        center.publisher(for: .favorites)
            .sink { [weak self] _ in self?.rebuild() }
            .store(in: &cancellables)
        
        center.publisher(for: .reload)
            .sink { [weak self] _ in self?.rebuild() }
            .store(in: &cancellables)
    }
    
    func rebuild() {
        showsTranslation = verbsService.shouldTranslationBeShown && hasTranslation
        showsSectionIndex = !isSearchActive && !verbsService.shouldSimilarBeShown
        
        sections = verbsService.headers.enumerated().map { index, header in
            VerbSection(id: index, header: header, verbs: verbsService.groupedItems[safe: index] ?? [])
        }
        searchResults = verbsService.searchedItems
        
        let items = isSearchActive ? verbsService.searchedItems : verbsService.items
        state = ListState(isSearchActive: isSearchActive,
                          isSearchTextEmpty: verbsService.searchText.isEmpty,
                          areItemsEmpty: items.isEmpty)
    }
}
