//
//  Voice.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

struct Voice: Swift.Identifiable, Equatable, Codable {
    
    let name: String
    let id: String
    let gender: Gender
    let region: Region
    
    static var current: Voice? {
        get {
            guard let data = UserDefaults.shared.data(for: .voice),
                  let voice = try? JSONDecoder().decode(Voice.self, from: data)
            else { return nil }
            return voice
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.shared.set(data, for: .voice)
            NotificationCenter.default.post(name: .reload, object: nil)
        }
    }
}
