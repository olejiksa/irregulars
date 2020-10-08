//
//  AudioService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class AudioService {
    
    private let synth = AVSpeechSynthesizer()
    private var utterance = AVSpeechUtterance(string: "")
    
    func play(text: String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.3
        synth.speak(utterance)
    }
}
