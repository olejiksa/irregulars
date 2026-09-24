//
//  Statistics.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class Statistics {
    
    private let consideredAsLearned = 3
    
    private(set) var info: [Verb: Int]
    
    @ObservationIgnored private let defaults = UserDefaults.shared
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()
    
    init() {
        guard let data = defaults.data(for: .statistics) else {
            info = [:]
            return
        }
            
        info = (try? decoder.decode([Verb: Int].self, from: data)) ?? [:]
    }
    
    func increase(_ verb: Verb) {
        let value = info[verb] ?? 0
        info[verb] = value + 1
        save()
    }
    
    func decrease(_ verb: Verb) {
        let value = info[verb] ?? 0
        info[verb] = max(value - 1, 0)
        save()
    }
    
    func save() {
        guard let encoded = try? encoder.encode(info) else { return }
        defaults.set(encoded, for: .statistics)
    }
    
    func clear() {
        info = [:]
        defaults.set(nil, for: .statistics)
    }
}
