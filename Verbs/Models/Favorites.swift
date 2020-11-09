//
//  Favorites.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class Favorites {
    
    var didUpdateBlock: (() -> ())?
    
    private(set) var verbs: Set<Verb>
    
    private let key = "favorites"
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        guard let data = defaults.value(forKey: key) as? Data else {
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
        defaults.set(encoded, forKey: key)
    }
}
