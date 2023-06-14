//
//  VoiceViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

struct VoiceViewModel {
    
    private let audioService: AudioService
    private let voiceService: VoiceService
    
    init() {
        voiceService = VoiceService()
        audioService = AudioService(voiceService: voiceService)
    }
    
    func items(for gender: Gender) -> [Voice] {
        voiceService.voices(gender: gender)
            .sorted { $0.name < $1.name }
            .map { voice in
                let region = Region(rawValue: String(voice.language.suffix(2))) ?? .unitedStates
                return Voice(name: voice.name, id: voice.identifier, gender: gender, region: region)
            }
    }
    
    func play(playHandler: @escaping Block, stopHandler: @escaping Block) {
        let text = "The quick brown fox jumps over the lazy dog"
        audioService.play(text: text, playHandler: playHandler, stopHandler: stopHandler)
    }
}
