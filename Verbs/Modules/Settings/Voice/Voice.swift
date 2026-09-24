//
//  Voice.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Voice: Identifiable, Equatable {
    
    let name: String
    let id: String
    let gender: Gender
    let region: Region
    
    static var current: Voice? {
        get {
            let id = UserDefaults.shared.string(for: .voice)
            return VoiceService().voices.first { $0.id == id }
        }
        set {
            guard let id = newValue?.id else { return }
            UserDefaults.shared.set(id, for: .voice)
        }
    }
}
