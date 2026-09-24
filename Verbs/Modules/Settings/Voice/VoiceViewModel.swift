//
//  VoiceViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

final class VoiceViewModel: ObservableObject {
    
    @Published var selectedItem: Voice? = .current
    @Published var isPlaying = false
    @Published var isShowingSpeakingRate = false
    
    private let audioService: AudioService
    private let voiceService: VoiceService
    
    init() {
        voiceService = VoiceService()
        audioService = AudioService(voiceService: voiceService)
    }
    
    func items(for gender: Gender) -> [Voice] {
        voiceService.voices
            .filter { $0.gender == gender }
            .sorted { $0.name < $1.name }
    }
    
    func play() {
        let text = "The quick brown fox jumps over the lazy dog"
        audioService.play(text: text) { [weak self] in
            self?.isPlaying = true
        } stopHandler: { [weak self] in
            self?.isPlaying = false
        }
    }
}
