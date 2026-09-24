//
//  AudioService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

@MainActor
final class AudioService: NSObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var text: String?
    private var playHandler: Block?
    private var stopHandler: Block?
    
    private let voiceService: VoiceService
    
    init(voiceService: VoiceService) {
        self.voiceService = voiceService
        super.init()
        synthesizer.delegate = self
    }
    
    func play(text: String, playHandler: @escaping Block, stopHandler: @escaping Block) {
        self.stopHandler?()
        
        self.playHandler = playHandler
        self.stopHandler = stopHandler
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            if self.text != text {
                play(text: text, playHandler: playHandler, stopHandler: stopHandler)
            }
        } else {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            let utterance = AVSpeechUtterance(string: text)
            let playbackSpeed = PlaybackSpeed(UserDefaults.shared.integer(for: .playbackSpeed))
            utterance.rate = playbackSpeed.rawValue
            utterance.voice = voiceService.voice(identifier: Voice.current?.id ?? "")
            synthesizer.speak(utterance)
        }
        
        self.text = text
    }
}

// MARK: - AVSpeechSynthesizerDelegate

/// `AVSpeechSynthesizerDelegate` is `Sendable` in the SDK, so these can arrive on any
/// thread. The handlers drive the UI, hence the hop back to the main actor.
extension AudioService: AVSpeechSynthesizerDelegate {
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in playHandler?() }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didContinue utterance: AVSpeechUtterance) {
        Task { @MainActor in playHandler?() }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didPause utterance: AVSpeechUtterance) {
        Task { @MainActor in stopHandler?() }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in stopHandler?() }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in stopHandler?() }
    }
}
