//
//  Preferences.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

/// Everything the reader can switch, in one observable place. Stored in the shared
/// suite, so the widget sees the same values.
@MainActor
@Observable
final class Preferences {
    
    // MARK: The verb list
    
    var showsRegularVerbs: Bool { didSet { write(showsRegularVerbs, .regularVerbs) } }
    var showsDerivatives: Bool { didSet { write(showsDerivatives, .derivatives) } }
    var showsTranslation: Bool { didSet { write(showsTranslation, .shouldTranslationBeShown) } }
    var groupsBySimilarity: Bool { didSet { write(groupsBySimilarity, .shouldSimilarBeShown) } }
    
    // MARK: The tests
    
    /// A separate pair from the list's: the reader sets them independently.
    var testsIncludeRegularVerbs: Bool { didSet { write(testsIncludeRegularVerbs, .regularVerbsTests) } }
    var testsIncludeDerivatives: Bool { didSet { write(testsIncludeDerivatives, .derivativesTests) } }
    var testsUseFavoritesOnly: Bool { didSet { write(testsUseFavoritesOnly, .favoritesOnly) } }
    
    // MARK: Speech
    
    var playbackSpeed: Int { didSet { write(playbackSpeed, .playbackSpeed) } }
    
    // MARK: Notifications
    
    var areNotificationsEnabled: Bool { didSet { write(areNotificationsEnabled, .notifications) } }
    var notificationsPerDay: Int { didSet { write(notificationsPerDay, .frequency) } }
    var notificationsSince: Int { didSet { write(notificationsSince, .since) } }
    var notificationsUntil: Int { didSet { write(notificationsUntil, .to) } }
    
    // MARK: Progress
    
    var translationAnswers: Int { didSet { write(translationAnswers, .translationAnswers) } }
    var writingAnswers: Int { didSet { write(writingAnswers, .writingAnswers) } }
    var sentencesAnswers: Int { didSet { write(sentencesAnswers, .sentencesAnswers) } }
    var listeningAnswers: Int { didSet { write(listeningAnswers, .listeningAnswers) } }
    
    // MARK: Housekeeping
    
    var reviewWorthyActionCount: Int { didSet { write(reviewWorthyActionCount, .reviewWorthyActionCount) } }
    var lastReviewRequestAppVersion: String? { didSet { write(lastReviewRequestAppVersion, .lastReviewRequestAppVersion) } }
    var hasLaunchedBefore: Bool { didSet { write(hasLaunchedBefore, .hasLaunchedBefore) } }
    
    @ObservationIgnored private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .shared) {
        self.defaults = defaults
        
        Self.registerDefaults(in: defaults)
        
        showsRegularVerbs = defaults.bool(for: .regularVerbs)
        showsDerivatives = defaults.bool(for: .derivatives)
        showsTranslation = defaults.bool(for: .shouldTranslationBeShown)
        groupsBySimilarity = defaults.bool(for: .shouldSimilarBeShown)
        
        testsIncludeRegularVerbs = defaults.bool(for: .regularVerbsTests)
        testsIncludeDerivatives = defaults.bool(for: .derivativesTests)
        testsUseFavoritesOnly = defaults.bool(for: .favoritesOnly)
        
        playbackSpeed = defaults.integer(for: .playbackSpeed)
        
        areNotificationsEnabled = defaults.bool(for: .notifications)
        notificationsPerDay = defaults.integer(for: .frequency)
        notificationsSince = defaults.integer(for: .since)
        notificationsUntil = defaults.integer(for: .to)
        
        translationAnswers = defaults.integer(for: .translationAnswers)
        writingAnswers = defaults.integer(for: .writingAnswers)
        sentencesAnswers = defaults.integer(for: .sentencesAnswers)
        listeningAnswers = defaults.integer(for: .listeningAnswers)
        
        reviewWorthyActionCount = defaults.integer(for: .reviewWorthyActionCount)
        lastReviewRequestAppVersion = defaults.string(for: .lastReviewRequestAppVersion)
        hasLaunchedBefore = defaults.bool(for: .hasLaunchedBefore)
    }
    
    /// Used when the reader erases the progress.
    func setAnswers(_ value: Int, for key: UserDefaults.Key) {
        switch key {
        case .translationAnswers:
            translationAnswers = value
        case .writingAnswers:
            writingAnswers = value
        case .sentencesAnswers:
            sentencesAnswers = value
        case .listeningAnswers:
            listeningAnswers = value
        default:
            break
        }
    }
    
    /// The values a fresh install starts from.
    static func registerDefaults(in defaults: UserDefaults = .shared) {
        defaults.register(true, for: .regularVerbs)
        defaults.register(true, for: .regularVerbsTests)
        defaults.register(true, for: .derivatives)
        defaults.register(true, for: .derivativesTests)
        defaults.register(2, for: .playbackSpeed)
        defaults.register(1, for: .frequency)
        defaults.register(540, for: .since)
        defaults.register(1260, for: .to)
    }
}

// MARK: - Private

private extension Preferences {
    
    func write(_ value: Any?, _ key: UserDefaults.Key) {
        defaults.set(value, for: key)
    }
}
