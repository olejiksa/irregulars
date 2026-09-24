//
//  TestSessionViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class TestSessionViewModel {
    
    let test: Test
    
    private(set) var sections: [TestSection] = []
    private(set) var answeredIDs: Set<String> = []
    var hint: String?
    var isShowingPlaybackSpeed = false
    
    /// Whether the microphone may be used, which the record rows read.
    private(set) var isMicrophoneAvailable = false
    
    /// Bumped whenever a new verb is drawn, so the view can announce the change.
    private(set) var questionToken = 0
    
    /// Called when the pool runs dry and there is nothing left to ask.
    var onFinish: (() -> Void)?
    
    private var items: [String]
    private let audioService: AudioService
    private let recordService: RecordService
    private let playerService: PlayerService
    private let catalogue: VerbCatalogue
    private let preferences: Preferences
    private let statistics: Statistics
    private let mistakes: Mistakes
    private let factory: TestQuestionFactory
    
    private var verb: Verb?
    private var currentKind: Test.Kind?
    private var wasHintUsed = false
    
    /// What the test screen asks for. The long initializer below stays for the tests,
    /// which hand in their own doubles.
    convenience init(test: Test, dependencies: AppDependencies) {
        let catalogue = dependencies.catalogue
        let preferences = dependencies.preferences
        
        self.init(audioService: dependencies.makeAudioService(),
                  recordService: .init(),
                  playerService: .init(),
                  catalogue: catalogue,
                  preferences: preferences,
                  statistics: dependencies.statistics,
                  mistakes: dependencies.mistakes,
                  demoService: .init(),
                  factory: TestQuestionFactory(catalogue: catalogue, preferences: preferences),
                  test: test)
    }
    
    init(audioService: AudioService,
         recordService: RecordService,
         playerService: PlayerService,
         catalogue: VerbCatalogue,
         preferences: Preferences,
         statistics: Statistics,
         mistakes: Mistakes,
         demoService: DemoService,
         factory: TestQuestionFactory,
         test: Test) {
        self.audioService = audioService
        self.recordService = recordService
        self.playerService = playerService
        self.catalogue = catalogue
        self.preferences = preferences
        self.statistics = statistics
        self.mistakes = mistakes
        self.factory = factory
        self.test = test
        
        // The filters have to be applied before the pool is taken, not after.
        let pool = catalogue.verbs(favoritesOnly: preferences.testsUseFavoritesOnly,
                                   includingRegular: preferences.testsIncludeRegularVerbs,
                                   includingDerived: preferences.testsIncludeDerivatives)
            .map(\.infinitive.value)
        
        items = FeatureToggle.isPaid ? pool : pool.filter(demoService.items.contains)
        
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
        
        Task { [weak self] in
            guard let self else { return }
            
            updateMicrophoneAvailability(await recordService.requestRecordPermission())
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
        
        verb = catalogue.verb(named: items.randomElement())
        
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
        
        let built = factory.build(with: kind, verb: verb, isMicrophoneAvailable: isMicrophoneAvailable)
        guard !built.isEmpty else { return false }
        
        sections = built
        return true
    }
    
    /// The record button and the "no access" block are built from the flag,
    /// so a change has to rebuild them.
    func updateMicrophoneAvailability(_ isAvailable: Bool) {
        guard isMicrophoneAvailable != isAvailable else { return }
        
        isMicrophoneAvailable = isAvailable
        buildSections()
    }
    
    func finishTask() {
        if !wasHintUsed {
            switch test {
            case .translation:
                preferences.translationAnswers += 1
            case .listening:
                preferences.listeningAnswers += 1
            case .sentences:
                preferences.sentencesAnswers += 1
            case .writing:
                preferences.writingAnswers += 1
            case .speaking:
                break
            }
            
            if let verb = verb {
                statistics.increase(verb)
            }
        } else if let verb = verb {
            statistics.decrease(verb)
            mistakes.add(verb)
        }
        
        nextQuestion()
    }
    
}
