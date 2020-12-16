//
//  UserDefaults+Key.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var shared = UserDefaults(suiteName: "group.olejiksa.verbs")!
    
    enum Key: String {
        case isPaid
        case shouldRegularVerbsBeShown
        case shouldDerivedFormsBeShown
        case shouldTranslationBeShown
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
    }
    
    func bool(for key: Key) -> Bool { bool(forKey: key.rawValue) }
    func data(for key: Key) -> Data? { data(forKey: key.rawValue) }
    func integer(for key: Key) -> Int { integer(forKey: key.rawValue) }
    func string(for key: Key) -> String? { string(forKey: key.rawValue) }
    
    func set(_ value: Any?, for key: Key) { setValue(value, forKey: key.rawValue) }
    func register(_ value: Any, for key: Key) { register(defaults: [key.rawValue: value]) }
}
