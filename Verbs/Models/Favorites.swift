//
//  Favorites.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class Favorites {
    
    var didUpdateBlock: Block?
    
    private(set) var verbs: Set<Verb>
    
    private let defaults = UserDefaults.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
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
        didUpdateBlock?()
        save()
    }
    
    func remove(_ verb: Verb) {
        verbs.remove(verb)
        didUpdateBlock?()
        save()
    }
    
    func save() {
        guard let encoded = try? encoder.encode(verbs) else { return }
        defaults.set(encoded, for: .favorites)
    }
}
