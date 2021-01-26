//
//  Gender.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

enum Gender: String, CaseIterable {
    
    case `default`
    case male
    case female
    
    var description: String { rawValue.localized }
    
    var speechGender: AVSpeechSynthesisVoiceGender {
        switch self {
        case .default:
            return .unspecified
        case .male:
            return .male
        case .female:
            return .female
        }
    }
    
    static var current: Gender {
        get {
            guard let string = UserDefaults.shared.string(for: .gender),
                  let gender = Gender(rawValue: string) else { return .default }
            return gender
        }
        set {
            UserDefaults.shared.set(newValue.rawValue, for: .gender)
        }
    }
}
