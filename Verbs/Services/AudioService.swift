//
//  AudioService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class AudioService: NSObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var text: String?
    private var playHandler: Block?
    private var stopHandler: Block?
    
    override init() {
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
            utterance.voice = AVSpeechSynthesisVoice(language: Language.english.rawValue)
            synthesizer.speak(utterance)
        }
        
        self.text = text
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension AudioService: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didStart utterance: AVSpeechUtterance) {
        playHandler?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didContinue utterance: AVSpeechUtterance) {
        playHandler?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didPause utterance: AVSpeechUtterance) {
        stopHandler?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didCancel utterance: AVSpeechUtterance) {
        stopHandler?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        stopHandler?()
    }
}
