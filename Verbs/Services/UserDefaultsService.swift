//
//  UserDefaultsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class UserDefaultsService {
    
    private enum Keys: String {
        case settings
    }
    
    private let defaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    func save(_ settings: Settings?) {
        guard let settings = settings else { return }
        let encoded = try? jsonEncoder.encode(settings)
        defaults.set(encoded, forKey: Keys.settings.rawValue)
    }
    
    func load() -> Settings? {
        guard
            let data = defaults.object(forKey: Keys.settings.rawValue) as? Data
        else { return nil }
        
        return try? jsonDecoder.decode(Settings.self, from: data)
    }
}
