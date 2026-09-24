//
//  TestSessionViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

@MainActor
final class TestSessionViewModel: ObservableObject {
    
    let test: Test
    
    @Published private(set) var sections: [TestSection] = []
    @Published private(set) var answeredIDs: Set<String> = []
    @Published var hint: String?
    
    /// Bumped whenever a new verb is drawn, so the view can announce the change.
    @Published private(set) var questionToken = 0
    
    /// Called when the pool runs dry and there is nothing left to ask.
    var onFinish: (() -> Void)?
    
    private var items: [String]
    private let audioService: AudioService
    private let recordService: RecordService
    private let playerService: PlayerService
    private let verbsService: VerbsService
    private let favoritesService: FavoritesService
    private let factory: TestQuestionFactory
    
    private var verb: Verb?
    private var currentKind: Test.Kind?
    private var wasHintUsed = false
    
    init(audioService: AudioService,
         recordService: RecordService,
         playerService: PlayerService,
         verbsService: VerbsService,
         favoritesService: FavoritesService,
         demoService: DemoService,
         factory: TestQuestionFactory,
         test: Test) {
        self.audioService = audioService
        self.recordService = recordService
        self.playerService = playerService
        self.verbsService = verbsService
        self.favoritesService = favoritesService
        self.factory = factory
        self.test = test
        
        switch (UserDefaults.shared.bool(for: .favoritesOnly), !UserDefaults.shared.bool(for: .isPaid)) {
        case (true, false):
            items = favoritesService.items.map(\.infinitive.value)
        case (false, false):
            items = verbsService.items.map(\.infinitive.value)
        case (_, true):
            items = verbsService.items.map(\.infinitive.value).filter(demoService.items.contains)
        }
        
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        
        nextQuestion()
    }
    
    // MARK: Question flow
    
    func skip() {
        nextQuestion()
    }
    
    func submit(_ field: InputField) {
        field.submit()
        
        let fields = inputFields
        guard fields.allSatisfy(\.isSubmitted) else { return }
        
        wasHintUsed = wasHintUsed || !fields.allSatisfy(\.isValid)
        
        Task {
            try? await Task.sleep(for: .milliseconds(750))
            finishTask()
        }
    }
    
    func select(_ answer: AnswerRow) {
        guard !answeredIDs.contains(answer.id) else { return }
        
        answeredIDs.insert(answer.id)
        
        guard answer.isCorrect else {
            wasHintUsed = true
            return
        }
        
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            finishTask()
        }
    }
    
    func showHint(for field: InputField) {
        guard let text = field.expected.first else { return }
        
        wasHintUsed = true
        hint = text
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: Audio
    
    func play(_ field: InputField) {
        guard let text = field.expected.first else { return }
        
        audioService.play(text: text) { [weak field] in
            field?.setPlaying(true)
        } stopHandler: { [weak field] in
            field?.setPlaying(false)
        }
    }
    
    func play(_ field: RecordField) {
        audioService.play(text: field.word.value) { [weak field] in
            field?.setPlaying(true)
        } stopHandler: { [weak field] in
            field?.setPlaying(false)
        }
    }
    
    func record(_ field: RecordField) {
        recordService.record { [weak field] in
            field?.setRecording(true)
        } stopHandler: { [weak field] in
            field?.setRecording(false)
        }
    }
    
    func compare(_ field: RecordField) {
        playerService.compare { [weak field] in
            field?.setComparing(true)
        } stopHandler: { [weak field] in
            field?.setComparing(false)
        }
    }
    
    // MARK: Microphone
    
    func checkAvailability() {
        guard test == .speaking else { return }
        
        // The current answer first, so the screen is right before any prompt appears.
        updateMicrophoneAvailability(recordService.isRecordPermissionGranted)
        
        recordService.checkAvailability { [weak self] isGranted in
            self?.updateMicrophoneAvailability(isGranted)
        }
    }
}

// MARK: - Private

private extension TestSessionViewModel {
    
    var inputFields: [InputField] {
        sections.flatMap(\.rows).compactMap {
            guard case .input(let field) = $0 else { return nil }
            return field
        }
    }
    
    func nextQuestion() {
        guard !items.isEmpty else {
            onFinish?()
            return
        }
        
        wasHintUsed = false
        answeredIDs = []
        
        verb = UserDefaults.shared.bool(for: .favoritesOnly) && FeatureToggle.isPaid
            ? favoritesService.verb(of: items.randomElement())
            : verbsService.verb(of: items.randomElement())
        
        guard let verb = verb,
              let index = items.firstIndex(of: verb.infinitive.value),
              let kind = test.kinds.randomElement()
        else {
            nextQuestion()
            return
        }
        
        items.remove(at: index)
        currentKind = kind
        
        guard buildSections() else {
            nextQuestion()
            return
        }
        
        questionToken += 1
    }
    
    /// Rebuilds the rows for the verb already on screen.
    @discardableResult
    func buildSections() -> Bool {
        guard let verb = verb, let kind = currentKind else { return false }
        
        let built = factory.build(with: kind, verb: verb)
        guard !built.isEmpty else { return false }
        
        sections = built
        return true
    }
    
    /// The record button and the "no access" block are built from the flag,
    /// so a change has to rebuild them.
    func updateMicrophoneAvailability(_ isAvailable: Bool) {
        guard Locator.isMicrophoneAvailable != isAvailable else { return }
        
        Locator.isMicrophoneAvailable = isAvailable
        buildSections()
    }
    
    func finishTask() {
        if !wasHintUsed {
            switch test {
            case .translation:
                increase(.translationAnswers)
            case .listening:
                increase(.listeningAnswers)
            case .sentences:
                increase(.sentencesAnswers)
            case .writing:
                increase(.writingAnswers)
            case .speaking:
                break
            }
            
            if let verb = verb {
                Locator.statistics.increase(verb)
            }
        } else if let verb = verb {
            Locator.statistics.decrease(verb)
            Locator.mistakes.add(verb)
        }
        
        nextQuestion()
    }
    
    func increase(_ key: UserDefaults.Key) {
        UserDefaults.shared.set(UserDefaults.shared.integer(for: key) + 1, for: key)
    }
}
