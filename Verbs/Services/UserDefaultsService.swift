//
//  UserDefaultsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class UserDefaultsService {
    
    enum Key: String {
        case isPaid
    }
    
    private let defaults = UserDefaults(suiteName: "group.olejiksa.verbs")
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    func save(_ settings: Settings?) {
        guard let settings = settings else { return }
        let encoded = try? jsonEncoder.encode(settings)
        defaults?.set(encoded, forKey: "settings")
    }
    
    func load() -> Settings? {
        guard
            let data = defaults?.object(forKey: "settings") as? Data
        else { return nil }
        
        return try? jsonDecoder.decode(Settings.self, from: data)
    }
    
    func load(by key: Key) -> Bool { defaults?.bool(forKey: key.rawValue) ?? false }
    func save(_ value: Bool, by key: Key) { defaults?.set(value, forKey: key.rawValue) }
}
