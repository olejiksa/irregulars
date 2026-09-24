//
//  TestPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

@MainActor
final class TestPresenter: NSObject {
    
    let test: Test
    let dataSource = SectionDataSource()
    var router: TestRouter?
    weak var viewController: TestViewController?
    
    private var items: [String]
    private let audioService: AudioService
    private let recordService: RecordService
    private let playerService: PlayerService
    private let verbsService: VerbsService
    private let favoritesService: FavoritesService
    private let demoService: DemoService
    private let itemsFactory: TestItemsFactory
    
    private var verb: Verb?
    private var wasHintUsed = false
    
    init(audioService: AudioService,
         recordService: RecordService,
         playerService: PlayerService,
         verbsService: VerbsService,
         favoritesService: FavoritesService,
         demoService: DemoService,
         itemsFactory: TestItemsFactory,
         test: Test) {
        self.verbsService = verbsService
        self.favoritesService = favoritesService
        self.demoService = demoService
        switch (UserDefaults.shared.bool(for: .favoritesOnly),
                !UserDefaults.shared.bool(for: .isPaid)) {
        case (true, false):
            self.items = favoritesService.items.map(\.infinitive.value)
        case (false, false):
            self.items = verbsService.items.map(\.infinitive.value)
        case (_, true):
            self.items = verbsService.items.map(\.infinitive.value).filter(demoService.items.contains)
        }
        self.audioService = audioService
        self.recordService = recordService
        self.playerService = playerService
        self.itemsFactory = itemsFactory
        self.test = test
        
        super.init()
        
        loadSettings()
        setupSections()
    }
    
    func reloadData() {
        configureRandomComposition()
        viewController?.reloadData()
    }
    
    func checkAvailability() {
        guard test == .speaking else { return }
        
        recordService.checkAvailability {
            Locator.isMicrophoneAvailable = $0
        }
    }
}

// MARK: - Private

private extension TestPresenter {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
    }
    
    func setupSections() {
        configureRandomComposition()
    }
    
    func configureRandomComposition() {
        guard !items.isEmpty else {
            router?.goBack()
            return
        }
        
        self.verb = UserDefaults.shared.bool(for: .favoritesOnly) && FeatureToggle.isPaid
            ? favoritesService.verb(of: items.randomElement())
            : verbsService.verb(of: items.randomElement())
        
        guard let verb = self.verb,
              let index = items.firstIndex(of: verb.infinitive.value),
              let currentTestKind = test.kinds.randomElement()
        else {
            wasHintUsed = false
            configureRandomComposition()
            viewController?.reloadData()
            return
        }
        
        items.remove(at: index)
        
        let sections = itemsFactory.build(with: currentTestKind,
                                          verb: verb,
                                          hint: hint,
                                          didEndEntering: didEndEntering,
                                          play: play,
                                          record: record,
                                          compare: compare,
                                          answerActionBlock: didAnswerTap)
        
        guard !sections.isEmpty else {
            wasHintUsed = false
            configureRandomComposition()
            viewController?.reloadData()
            return
        }
        
        dataSource.setup(sections)
    }
    
    func didEndEntering() {
        guard let items = dataSource.items(of: InputItem.self) as? [InputItem],
              items.allSatisfy(\.isFilled) else { return }
        
        wasHintUsed = !items.allSatisfy(\.isValid)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.finishTask()
        }
    }
    
    func finishTask() {
        if !wasHintUsed {
            switch test {
            case .translation:
                let answeredCorrectlyCount = UserDefaults.shared.integer(for: .translationAnswers)
                UserDefaults.shared.set(answeredCorrectlyCount + 1, for: .translationAnswers)
            case .listening:
                let answeredCorrectlyCount = UserDefaults.shared.integer(for: .listeningAnswers)
                UserDefaults.shared.set(answeredCorrectlyCount + 1, for: .listeningAnswers)
            case .sentences:
                let answeredCorrectlyCount = UserDefaults.shared.integer(for: .sentencesAnswers)
                UserDefaults.shared.set(answeredCorrectlyCount + 1, for: .sentencesAnswers)
            case .writing:
                let answeredCorrectlyCount = UserDefaults.shared.integer(for: .writingAnswers)
                UserDefaults.shared.set(answeredCorrectlyCount + 1, for: .writingAnswers)
            case .speaking:
                break
            }
            
            guard let verb = verb else { return }
            Locator.statistics.increase(verb)
        } else {
            guard let verb = verb else { return }
            Locator.statistics.decrease(verb)
            Locator.mistakes.add(verb)
        }
        
        wasHintUsed = false
        configureRandomComposition()
        viewController?.reloadData()
    }
    
    func play(text: String, playHandler: @escaping Block, stopHandler: @escaping Block) {
        audioService.play(text: text, playHandler: playHandler, stopHandler: stopHandler)
    }
    
    func record(recordHandler: @escaping Block, stopHandler: @escaping Block) {
        recordService.record(recordHandler: recordHandler, stopHandler: stopHandler)
    }
    
    func compare(recordHandler: @escaping Block, stopHandler: @escaping Block) {
        playerService.compare(recordHandler: recordHandler, stopHandler: stopHandler)
    }
    
    func hint(text: String) {
        wasHintUsed = true
        router?.show(hint: text)
    }
    
    func didAnswerTap(_ item: ItemProtocol) {
        guard let answerItem = item as? AnswerItem else { return }
        
        if answerItem.isCorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.finishTask()
            }
        } else {
            wasHintUsed = true
        }
    }
}

// MARK: - UITableViewDelegate

extension TestPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let actionableItem = dataSource.item(at: indexPath) as? Actionable,
           let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}
