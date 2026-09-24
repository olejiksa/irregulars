//
//  Mistakes.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class Mistakes {
    
    private(set) var info: [String: Int]
    
    @ObservationIgnored private let defaults = UserDefaults.shared
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()
    
    init() {
        guard let data = defaults.data(for: .mistakes) else {
            info = [:]
            return
        }
            
        info = (try? decoder.decode([String: Int].self, from: data)) ?? [:]
    }
    
    func add(_ verb: Verb) {
        let key = verb.infinitive.value
        let value = info[key] ?? 0
        info[key] = value + 1
        save()
    }
    
    func remove(_ verb: Verb) {
        let key = verb.infinitive.value
        info[key] = 0
        save()
    }
    
    func clear() {
        info = [:]
        defaults.set(nil, for: .mistakes)
    }
}


// MARK: - Private

private extension Mistakes {
    
    func save() {
        guard let encoded = try? encoder.encode(info) else { return }
        defaults.set(encoded, for: .mistakes)
    }
}
