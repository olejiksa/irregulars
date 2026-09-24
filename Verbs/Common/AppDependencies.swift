//
//  AppDependencies.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

/// The object graph, built once. Everything below receives what it needs through an
/// initializer; only the entry point and the two UIKit delegates reach for the shared
/// instance, because they are created by the system rather than by us.
@MainActor
final class AppDependencies {
    
    static let shared = AppDependencies()
    
    let preferences: Preferences
    let favorites: Favorites
    let statistics: Statistics
    let mistakes: Mistakes
    let catalogue: VerbCatalogue
    let purchaseService: PurchaseService
    let router: AppRouter
    
    init(defaults: UserDefaults = .shared) {
        preferences = Preferences(defaults: defaults)
        favorites = Favorites()
        statistics = Statistics()
        mistakes = Mistakes()
        catalogue = VerbCatalogue(favorites: favorites)
        purchaseService = PurchaseService()
        router = AppRouter()
    }
    
    // MARK: Screens that build their own short-lived collaborators
    
    func makeAudioService() -> AudioService {
        AudioService(voiceService: .init(), preferences: preferences)
    }
    
    func makeRateService() -> RateService {
        RateService(preferences: preferences)
    }
    
    func makeNotificationService() -> NotificationService {
        NotificationService(catalogue: catalogue, calendarService: .init(), preferences: preferences)
    }
}

// MARK: - Environment

/// For views deep enough that threading the graph through every initializer would be
/// noise. Views that build a view model in `@State` take what they need as a parameter
/// instead, because the environment is not readable that early.
private struct AppDependenciesKey: EnvironmentKey {
    
    static var defaultValue: AppDependencies {
        MainActor.assumeIsolated { .shared }
    }
}

extension EnvironmentValues {
    
    var dependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
