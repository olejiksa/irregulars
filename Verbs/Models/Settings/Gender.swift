//
//  Gender.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

enum Gender: String, CaseIterable, Codable {
    
    case male
    case female
    
    var description: String { rawValue.localized }
    
    var speechGender: AVSpeechSynthesisVoiceGender {
        switch self {
        case .male:
            return .male
        case .female:
            return .female
        }
    }
}
