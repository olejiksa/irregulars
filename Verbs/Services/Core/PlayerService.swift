//
//  PlayerService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 04.04.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class PlayerService: NSObject {
    
    private var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    private var recordHandler: Block?
    private var stopHandler: Block?
    
    func compare(recordHandler: @escaping Block, stopHandler: @escaping Block) {
        self.recordHandler = recordHandler
        self.stopHandler = stopHandler
        
        if isPlaying {
            stop()
        } else {
            play()
        }
    }
}

// MARK: - Private

private extension PlayerService {
    
    func play() {
        preparePlayer()
        audioPlayer?.play()
        isPlaying = true
        recordHandler?()
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        stopHandler?()
    }
    
    func preparePlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            audioPlayer = nil
            print("AVAudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
}

// MARK: - AVAudioPlayerDelegate

extension PlayerService: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        stopHandler?()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else { return }
        print("Error while playing audio \(error.localizedDescription)")
    }
}
