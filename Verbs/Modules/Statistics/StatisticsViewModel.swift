//
//  StatisticsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/6/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import Combine
import Observation

@MainActor
@Observable
final class StatisticsViewModel {
    
    @ObservationIgnored private var cancellable: AnyCancellable?
    
    init() {
        cancellable = publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaid in self?.isPaid = isPaid }
        rateService.requestReviewIfAppropriate(minimumReviewWorthyActionCount: 10)
        setup()
    }
    
    var hasTranslation: Bool {
        languageService.hasTranslation
    }
    
    var counts: [Int] {
        [demoService.items.count, verbsService.items.count]
    }
    
    // MARK: Services
    
    private let demoService = DemoService()
    private let languageService = LanguageService()
    private let hapticService = HapticService()
    private let rateService = RateService()
    private let verbsService = VerbsService()
    
    // MARK: Publishers
    
    let publisher = UserDefaults.shared
        .publisher(for: \.isPaid)
    
    // MARK: Published
    
    var isPaid = FeatureToggle.isPaid
    var isShowingPaywall = false
    
    var learnedVerbsCount = 0
    var versbCount = 0
    var wordsInProgressCount = 0
    
    var answeredCorrectlyTranslation = 0
    var answeredCorrectlyWriting = 0
    var answeredCorrectlySentences = 0
    var answeredCorrectlyListening = 0
    var answeredCorrectlyTotal = 0
    
    var isShowingEraseLearnedVerbsAlert = false
    var isShowingEraseCorrectAnswersAlert = false
    
    // MARK: Methods
    
    func startErasing(_ statisticsKind: StatisticsKind) {
        hapticService.generateHapticFeedback(for: .notification(.warning))
        
        switch statisticsKind {
        case .correctAnswers:
            isShowingEraseCorrectAnswersAlert = true
        case .learnedVerbs:
            isShowingEraseLearnedVerbsAlert = true
        }
    }
    
    func erase(_ statisticsKind: StatisticsKind) {
        switch statisticsKind {
        case .correctAnswers:
            [.translationAnswers, .writingAnswers, .sentencesAnswers, .listeningAnswers].forEach {
                UserDefaults.shared.set(0, for: $0)
            }
        case .learnedVerbs:
            Locator.statistics.clear()
        }
        
        setup()
    }
}

// MARK: - Private
private extension StatisticsViewModel {
    
    func setup() {
        let statisticsModel = prepareStatisticsModel()
        
        learnedVerbsCount = statisticsModel.learnedWordsCount
        versbCount = statisticsModel.verbsCount
        wordsInProgressCount = statisticsModel.wordsInProgressCount
        
        answeredCorrectlyTranslation = statisticsModel.translationAnswersCount
        answeredCorrectlyWriting = statisticsModel.formsAnswersCount
        answeredCorrectlySentences = statisticsModel.sentenceAnswersCount
        answeredCorrectlyListening = statisticsModel.listeningAnswersCount
        answeredCorrectlyTotal = statisticsModel.totalAnswersCount
    }
    
    func prepareStatisticsModel() -> StatisticsModel {
        let answeredCorrectlyTranslation = UserDefaults.shared.integer(for: .translationAnswers)
        let answeredCorrectlyWriting = UserDefaults.shared.integer(for: .writingAnswers)
        let answeredCorrectlySentences = UserDefaults.shared.integer(for: .sentencesAnswers)
        let answeredCorrectlyListening = UserDefaults.shared.integer(for: .listeningAnswers)
        let answeredCorrectlyTotal = answeredCorrectlyTranslation +
            answeredCorrectlyWriting +
            answeredCorrectlySentences +
            answeredCorrectlyListening
        
        let learnedCount = Locator.statistics.info.filter { $0.value >= 3 }.count
        let inProgressCount = Locator.statistics.info.filter { $0.value > 0 && $0.value < 3 }.count
        let verbsCount = verbsService.items.count

        let mistakes = verbsService.items
            .filter { !Locator.favorites.verbs.contains($0) &&
                (Locator.mistakes.info[$0.infinitive.value] ?? 0) > 0 }
            .first(count: 5)
        
        return .init(verbsCount: verbsCount,
                     learnedWordsCount: learnedCount,
                     wordsInProgressCount: inProgressCount,
                     totalAnswersCount: answeredCorrectlyTotal,
                     translationAnswersCount: answeredCorrectlyTranslation,
                     formsAnswersCount: answeredCorrectlyWriting,
                     sentenceAnswersCount: answeredCorrectlySentences,
                     listeningAnswersCount: answeredCorrectlyListening,
                     mistakes: mistakes)
    }
    
    func prepareUITestsStatisticsModel() -> StatisticsModel {
        let answeredCorrectlyTranslation = 10
        let answeredCorrectlyWriting = 20
        let answeredCorrectlySentences = 30
        let answeredCorrectlyListening = 40
        let answeredCorrectlyTotal = answeredCorrectlyTranslation +
            answeredCorrectlyWriting +
            answeredCorrectlySentences +
            answeredCorrectlyListening
        
        let learnedCount = 50
        let inProgressCount = 100
        let verbsCount = verbsService.items.count

        let mistakes = [verbsService.randomItem].compactMap { $0 }
        
        return .init(verbsCount: verbsCount,
                     learnedWordsCount: learnedCount,
                     wordsInProgressCount: inProgressCount,
                     totalAnswersCount: answeredCorrectlyTotal,
                     translationAnswersCount: answeredCorrectlyTranslation,
                     formsAnswersCount: answeredCorrectlyWriting,
                     sentenceAnswersCount: answeredCorrectlySentences,
                     listeningAnswersCount: answeredCorrectlyListening,
                     mistakes: mistakes)
    }
}
