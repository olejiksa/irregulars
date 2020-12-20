//
//  VoiceService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class VoiceService {
    
    private let englishVoices: [AVSpeechSynthesisVoice]
    
    init() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        englishVoices = voices.filter { $0.language.hasPrefix(Language.english.rawValue) }
    }
    
    func voices(gender: Gender) -> [(language: String, name: String)] {
        englishVoices.filter { $0.gender == gender.speechGender }.map { ($0.language, $0.name) }
    }
    
    func voice(gender: Gender, region: Region) -> AVSpeechSynthesisVoice? {
        let voicesByGender = englishVoices.filter { $0.gender == gender.speechGender }
        return voicesByGender.filter { $0.language.hasSuffix(region.rawValue) }.first
    }
}
