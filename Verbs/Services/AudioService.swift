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
    private var myUtterance = AVSpeechUtterance(string: "")
    
    func play(text: String) {
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
}
