//
//  RootView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    private let dependencies: AppDependencies
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var allVerbs: ListViewModel
    @State private var favorites: ListViewModel
    @State private var tests: TestsViewModel
    
    @State private var isShowingEmptyFavorites = false
    @State private var isShowingPaywall = false
    @State private var isShowingOnboarding: Bool
    @State private var accentColor = AccentColor.current
    
    private var router: AppRouter { dependencies.router }
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        
        _allVerbs = State(wrappedValue: ListViewModel(favoritesOnly: false,
                                                      catalogue: dependencies.catalogue,
                                                      preferences: dependencies.preferences,
                                                      favorites: dependencies.favorites))
        _favorites = State(wrappedValue: ListViewModel(favoritesOnly: true,
                                                       catalogue: dependencies.catalogue,
                                                       preferences: dependencies.preferences,
                                                       favorites: dependencies.favorites))
        _tests = State(wrappedValue: TestsViewModel(languageService: .init(),
                                                    preferences: dependencies.preferences,
                                                    favorites: dependencies.favorites))
        _isShowingOnboarding = State(wrappedValue: FeatureToggle.isOnboardingAvailable(dependencies.preferences))
    }
    
    var body: some View {
        @Bindable var router = dependencies.router
        
        return Group {
            if horizontalSizeClass == .compact {
                tabs
            } else {
                split
            }
        }
        .onAppear(perform: connect)
        .onChange(of: horizontalSizeClass) { updateTitles() }
        .onChange(of: router.printRequests) {
            allVerbs.print()
        }
        .onChange(of: router.verbsRoute) { _, route in
            // Returning from a verb leaves the row highlighted otherwise.
            guard route == nil else { return }
            
            allVerbs.clearSelection()
            favorites.clearSelection()
        }
        .onChange(of: router.pendingSearch) { _, text in
            guard let text = text else { return }
            
            allVerbs.searchText = text
            router.pendingSearch = nil
        }
        .alert("empty_favorites_title", isPresented: $isShowingEmptyFavorites) {
            Button("ok", role: .cancel) {}
        } message: {
            Text("empty_favorites")
        }
        .sheet(isPresented: $isShowingPaywall) {
            PaywallView(purchaseService: dependencies.purchaseService)
        }
        .sheet(item: $router.menuScreen) { screen in
            NavigationStack {
                switch screen {
                case .voice:
                    VoiceView(settingsViewModel: .init(dependencies: dependencies),
                              dependencies: dependencies)
                case .notifications:
                    NotificationsView(settingsViewModel: .init(dependencies: dependencies),
                                      dependencies: dependencies)
                case .paywall:
                    PaywallView(purchaseService: dependencies.purchaseService)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnboardingView()
                .onDisappear { dependencies.preferences.hasLaunchedBefore = true }
        }
        .environment(\.dependencies, dependencies)
        .tint(accentColor.colorSwiftUI)
        .onReceive(NotificationCenter.default.publisher(for: .reload)) { _ in
            accentColor = .current
        }
    }
}

// MARK: - Layout

private extension RootView {
    
    /// `NavigationSplitView` gives each column its own navigation container, so a
    /// column only needs a `NavigationStack` when it pushes within itself — and then
    /// the stack's path belongs to the router, never to the column.
    var split: some View {
        NavigationSplitView {
            SidebarView(selection: sidebarSelection, favorites: dependencies.favorites)
        } content: {
            contentColumn
        } detail: {
            detailColumn
        }
    }
    
    var tabs: some View {
        TabView(selection: tabSelection) {
            NavigationStack(path: router.verbsPath) {
                ListView(viewModel: allVerbs)
                    .navigationDestination(for: VerbsRoute.self, destination: view(for:))
            }
            .tabItem { Label("verbs", systemImage: SystemIcon.bookFill.rawValue) }
            .accessibilityIdentifier(AccessibilityIdentifier.verbsTab.rawValue)
            .tag(SidebarDestination.all)
            
            NavigationStack(path: router.verbsPath) {
                ListView(viewModel: favorites)
                    .navigationDestination(for: VerbsRoute.self, destination: view(for:))
            }
            .tabItem { Label("favorites", systemImage: SystemIcon.starFill.rawValue) }
            .accessibilityIdentifier(AccessibilityIdentifier.favoritesTab.rawValue)
            .tag(SidebarDestination.favorites)
            
            NavigationStack(path: router.testsPath) {
                TestsView(viewModel: tests)
                    .navigationDestination(for: TestsRoute.self, destination: view(for:))
            }
            .tabItem { Label("tests", systemImage: SystemIcon.puzzleFill.rawValue) }
            .accessibilityIdentifier(AccessibilityIdentifier.testsTab.rawValue)
            .tag(SidebarDestination.tests)
            
            NavigationStack(path: router.settingsPath) {
                SettingsView(dependencies: dependencies)
            }
            .tabItem { Label("settings", systemImage: SystemIcon.gearFill.rawValue) }
                .accessibilityIdentifier(AccessibilityIdentifier.settingsTab.rawValue)
                .tag(SidebarDestination.settings)
        }
    }
    
    /// The lists hand their selection to the router, which the detail column reads;
    /// only the settings push onto a stack, and that stack's path is the router's.
    @ViewBuilder
    var contentColumn: some View {
        switch router.destination {
        case .all:
            ListView(viewModel: allVerbs)
        case .favorites:
            ListView(viewModel: favorites)
        case .tests:
            TestsView(viewModel: tests)
        case .settings:
            NavigationStack(path: router.settingsPath) {
                SettingsView(dependencies: dependencies)
            }
        }
    }
    
    @ViewBuilder
    var detailColumn: some View {
        switch (router.destination, router.verbsRoute, router.testsRoute) {
        case (.tests, _, .some(let route)):
            view(for: route)
        case (_, .some(let route), _):
            view(for: route)
        default:
            EmptyStateView(destination: router.destination)
        }
    }
    
    /// The detail column keeps the same place in the view tree, so the screen has to
    /// say which route it is showing. Without that its `@State` outlives the route and
    /// the reader sees the verb they left behind.
    @ViewBuilder
    func view(for route: VerbsRoute) -> some View {
        switch route {
        case .verb(let verb):
            DetailScreen(verb: verb, dependencies: dependencies)
                .id(route)
        }
    }
    
    @ViewBuilder
    func view(for route: TestsRoute) -> some View {
        switch route {
        case .test(let test):
            TestSessionScreen(test: test, dependencies: dependencies) { router.testsRoute = nil }
                .id(route)
        case .statistics:
            StatisticsView(dependencies: dependencies)
        }
    }
}

// MARK: - Wiring

private extension RootView {
    
    var sidebarSelection: Binding<SidebarDestination?> {
        .init(get: { router.destination },
              set: { router.destination = $0 ?? .all })
    }
    
    var tabSelection: Binding<SidebarDestination> {
        .init(get: { router.destination },
              set: { destination in
                  // Tapping the current tab scrolls its list back to the top.
                  if destination == router.destination {
                      scrollToTop(destination)
                  }
                  
                  router.destination = destination
              })
    }
    
    func scrollToTop(_ destination: SidebarDestination) {
        switch destination {
        case .all:
            allVerbs.scrollToTop()
        case .favorites:
            favorites.scrollToTop()
        case .tests:
            tests.scrollToTop()
        case .settings:
            break
        }
    }
    
    /// The all-verbs list is called "verbs" beside a tab bar and "all" beside the sidebar.
    func updateTitles() {
        allVerbs.title = horizontalSizeClass == .compact ? "verbs".localized : "all".localized
    }
    
    func connect() {
        allVerbs.onSelect = { router.open($0) }
        favorites.onSelect = { router.open($0) }
        favorites.title = "favorites".localized
        updateTitles()
        
        tests.onSelect = { test in
            guard let test = test else {
                router.showStatistics()
                return
            }
            
            router.destination = .tests
            router.testsRoute = .test(test)
        }
        tests.onEmptyFavorites = { isShowingEmptyFavorites = true }
        tests.onPaywall = { isShowingPaywall = true }
    }
}

// MARK: - Pushed screens

/// Each screen owns its view model, so a redraw of the container does not throw away
/// what the reader has typed or recorded. The route's identity, set where the screen is
/// built, is what decides when that state should start over instead.
private struct DetailScreen: View {
    
    @State private var viewModel: DetailViewModel
    
    init(verb: Verb, dependencies: AppDependencies) {
        _viewModel = State(wrappedValue: DetailViewModel(verb: verb, dependencies: dependencies))
    }
    
    var body: some View {
        DetailView(viewModel: viewModel)
    }
}

private struct TestSessionScreen: View {
    
    private let onFinish: () -> Void
    
    @State private var viewModel: TestSessionViewModel
    
    init(test: Test, dependencies: AppDependencies, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        _viewModel = State(wrappedValue: TestSessionViewModel(test: test, dependencies: dependencies))
    }
    
    var body: some View {
        TestSessionView(viewModel: viewModel)
            .onAppear {
                viewModel.onFinish = onFinish
                viewModel.checkAvailability()
            }
    }
}
