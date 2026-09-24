//
//  SpeechRecognitionService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import AVFoundation
import Speech

/// Hears a word said out loud and reports what it heard. Everything stays on the
/// device: the recogniser is forbidden from falling back on a server, so no audio and
/// no transcript ever leave the phone.
@MainActor
final class SpeechRecognitionService {

    enum Failure: Error {
        case unavailable
    }

    /// The verbs are English whatever language the app itself is in.
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let engine = AVAudioEngine()

    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var silence: Task<Void, Never>?
    private var heard = ""
    private var onHeard: ((String) -> Void)?
    private var onFinish: ((String) -> Void)?

    /// How long a pause ends the attempt, before and after the first word.
    private enum Pause {
        static let beforeSpeech = Duration.seconds(5)
        static let afterSpeech = Duration.milliseconds(1200)
    }

    var isAuthorized: Bool {
        SFSpeechRecognizer.authorizationStatus() == .authorized
    }

    /// On-device recognition is a promise the usage description makes, so a device that
    /// cannot keep it counts as having no recogniser at all rather than quietly
    /// sending the reader's voice to a server.
    var isAvailable: Bool {
        guard let recognizer else { return false }
        
        return recognizer.isAvailable && recognizer.supportsOnDeviceRecognition
    }

    /// `nonisolated` on purpose: the Speech headers do not mark this handler
    /// `@Sendable`, so from a `@MainActor` context it would inherit that isolation and
    /// assert the main queue — which is not where the framework calls it back.
    nonisolated func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    /// Listens until the reader stops speaking or `stop()` is called. `onHeard` reports
    /// the words as they arrive; `onFinish` carries the last of them.
    func start(expecting word: String,
               onHeard: @escaping (String) -> Void,
               onFinish: @escaping (String) -> Void) throws {
        cancel()

        guard let recognizer, isAvailable else { throw Failure.unavailable }

        self.onHeard = onHeard
        self.onFinish = onFinish
        heard = ""

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord,
                                mode: .measurement,
                                options: [.duckOthers, .defaultToSpeaker])
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true
        request.addsPunctuation = false
        request.taskHint = .search
        // Tilts the recogniser towards the form being drilled, which is the whole
        // reason single words come back reliably at all.
        request.contextualStrings = [word]
        self.request = request

        let node = engine.inputNode
        // The tap runs off the main actor and the request is not `Sendable`, but it is
        // the only thing that touches it while the engine is running.
        nonisolated(unsafe) let sink = request
        node.installTap(onBus: 0, bufferSize: 1024, format: node.outputFormat(forBus: 0)) { buffer, _ in
            sink.append(buffer)
        }

        engine.prepare()
        try engine.start()

        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            // `SFSpeechRecognitionResult` is not `Sendable`, so nothing but the text
            // it holds crosses back to the main actor.
            let text = result?.bestTranscription.formattedString
            let isFinal = result?.isFinal ?? false
            let hasFailed = error != nil

            Task { @MainActor [weak self] in
                self?.handle(text: text, isFinal: isFinal, hasFailed: hasFailed)
            }
        }

        waitForSilence(for: Pause.beforeSpeech)
    }

    /// Ends the attempt and reports whatever was heard by then.
    func stop() {
        guard task != nil else { return }

        let finish = onFinish
        let text = heard
        cancel()
        finish?(text)
    }

    /// Ends the attempt and reports nothing.
    func cancel() {
        silence?.cancel()
        silence = nil

        if engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }

        request?.endAudio()
        request = nil

        task?.cancel()
        task = nil

        onHeard = nil
        onFinish = nil

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

// MARK: - Matching

extension SpeechRecognitionService {

    /// Whether the expected form is among the words that came back. The reader may say
    /// a whole phrase around it, and the recogniser adds no punctuation of its own.
    static func heard(_ transcript: String, matches expected: String) -> Bool {
        let expected = normalized(expected)

        guard !expected.isEmpty else { return false }

        return words(in: transcript).contains(expected)
    }

    private static func words(in text: String) -> [String] {
        text.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map(normalized)
            .filter { !$0.isEmpty }
    }

    private static func normalized(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .init(identifier: "en_US"))
    }
}

// MARK: - Private

private extension SpeechRecognitionService {

    func handle(text: String?, isFinal: Bool, hasFailed: Bool) {
        if let text, !text.isEmpty {
            heard = text
            onHeard?(text)
        }

        guard !isFinal, !hasFailed else {
            stop()
            return
        }

        waitForSilence(for: heard.isEmpty ? Pause.beforeSpeech : Pause.afterSpeech)
    }

    /// A word said on its own never makes the recogniser call the result final, so the
    /// pause after it is what ends the attempt.
    func waitForSilence(for duration: Duration) {
        silence?.cancel()
        silence = Task { [weak self] in
            try? await Task.sleep(for: duration)

            guard !Task.isCancelled else { return }

            self?.stop()
        }
    }
}
