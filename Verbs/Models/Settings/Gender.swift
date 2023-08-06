//
//  Gender.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

enum Gender: String, CaseIterable {
    
    case male
    case female
    
    var description: String { rawValue.localized }
    
    init?(speechGender: AVSpeechSynthesisVoiceGender) {
        switch speechGender {
        case .male:
            self = .male
        case .female:
            self = .female
        case .unspecified:
            return nil
        @unknown default:
            return nil
        }
    }
    
    var speechGender: AVSpeechSynthesisVoiceGender {
        switch self {
        case .male:
            return .male
        case .female:
            return .female
        }
    }
}
