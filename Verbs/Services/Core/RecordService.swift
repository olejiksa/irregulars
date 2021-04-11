//
//  RecordService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.04.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import AVFoundation

final class RecordService: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    private var recordHandler: Block?
    private var stopHandler: Block?
    
    func checkAvailability(availabilityBlock: @escaping BoolBlock) {
        recordingSession = AVAudioSession.sharedInstance()
        
        try? recordingSession?.setCategory(.playAndRecord, mode: .default)
        try? recordingSession?.setActive(true)
        recordingSession?.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                availabilityBlock(allowed)
            }
        }
    }
    
    func record(recordHandler: @escaping Block, stopHandler: @escaping Block) {
        self.recordHandler = recordHandler
        self.stopHandler = stopHandler
        
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

// MARK: - Private

private extension RecordService {
    
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            recordHandler?()
//            recordButton.setTitle("Tap to Stop", for: .normal)
//            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        stopHandler?()
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
//
//        playButton.isEnabled = true
//        recordButton.isEnabled = true
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

// MARK: - AVAudioRecorderDelegate

extension RecordService: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard !flag else { return }
        finishRecording(success: false)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        guard let error = error else { return }
        print("Error while recording audio \(error.localizedDescription)")
    }
}
