//
//  UserDefaults+Key.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    // UserDefaults is thread safe, but it is not marked Sendable.
    nonisolated(unsafe) static let shared = UserDefaults(suiteName: "group.olejiksa.verbs")!
    
    enum Key: String {
        case isPaid
        case regularVerbs
        case regularVerbsTests
        case derivatives
        case derivativesTests
        case shouldTranslationBeShown
        case shouldSimilarBeShown
        case favorites
        case favoritesOnly
        case playbackSpeed
        case translationAnswers
        case writingAnswers
        case sentencesAnswers
        case listeningAnswers
        case accentColor
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
        case statistics
        case voice
        case notifications
        case frequency
        case since
        case to
        case mistakes
        case hasLaunchedBefore
    }
    
    func bool(for key: Key) -> Bool { bool(forKey: key.rawValue) }
    func data(for key: Key) -> Data? { data(forKey: key.rawValue) }
    func integer(for key: Key) -> Int { integer(forKey: key.rawValue) }
    func string(for key: Key) -> String? { string(forKey: key.rawValue) }
    
    func set(_ value: Any?, for key: Key) { setValue(value, forKey: key.rawValue) }
    func register(_ value: Any, for key: Key) { register(defaults: [key.rawValue: value]) }
}

extension UserDefaults {
    
    @objc dynamic private(set) var isPaid: Bool {
        get {
            UserDefaults.shared.bool(for: .isPaid)
        }
        set {
            UserDefaults.shared.set(newValue, for: .isPaid)
        }
    }
}
