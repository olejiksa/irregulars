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
    private var playHandler: (() -> Void)?
    private var stopHandler: (() -> Void)?
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func play(text: String, playHandler: @escaping () -> Void, stopHandler: @escaping () -> Void) {
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
            utterance.rate = 0.3
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
