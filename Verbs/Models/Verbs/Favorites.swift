//
//  Favorites.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class Favorites {
    
    private(set) var verbs: Set<Verb>
    
    @ObservationIgnored private let defaults = UserDefaults.shared
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()
    
    var shouldPaywallBeShown: Bool { verbs.count >= 10 && !FeatureToggle.isPaid }
    
    init() {
        guard let data = defaults.data(for: .favorites) else {
            verbs = []
            return
        }
            
        verbs = (try? decoder.decode(Set<Verb>.self, from: data)) ?? []
    }
    
    func add(_ verb: Verb) {
        verbs.insert(verb)
        save()
    }
    
    func remove(_ verb: Verb) {
        verbs.remove(verb)
        save()
    }
}

// MARK: - Private

private extension Favorites {
    
    func save() {
        guard let encoded = try? encoder.encode(verbs) else { return }
        defaults.set(encoded, for: .favorites)
        NotificationCenter.default.post(name: .favorites,
                                        object: nil,
                                        userInfo: nil)
    }
}
