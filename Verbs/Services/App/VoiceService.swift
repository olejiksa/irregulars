//
//  VoiceService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class VoiceService {
    
    let voices: [Voice]
    private let englishVoices: [AVSpeechSynthesisVoice]
    
    init() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        englishVoices = voices.filter { $0.language.hasPrefix(Language.english.rawValue) }
        self.voices = englishVoices.compactMap {
            guard let region = Region(rawValue: String($0.language.suffix(2))),
                  let gender = Gender(speechGender: $0.gender) else { return nil }
            
            return Voice(
                name: $0.name,
                id: $0.identifier,
                gender: gender,
                region: region
            )
        }
    }
    
    func voice(identifier: String) -> AVSpeechSynthesisVoice? {
        englishVoices.first { $0.identifier == identifier } ??
            englishVoices.first { $0.language.suffix(2) == Region.unitedStates.rawValue }
    }
}
