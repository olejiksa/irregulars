//
//  PlaybackSpeed.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum PlaybackSpeed: Float {
    
    case verySlow = 0.1
    case slow = 0.2
    case medium = 0.3
    case fast = 0.4
    case veryFast = 0.5
    
    init(_ intValue: Int) {
        switch intValue {
        case 0:
            self = .verySlow
        case 1:
            self = .slow
        case 2:
            self = .medium
        case 3:
            self = .fast
        case 4:
            self = .veryFast
        default:
            self = .medium
        }
    }
}
