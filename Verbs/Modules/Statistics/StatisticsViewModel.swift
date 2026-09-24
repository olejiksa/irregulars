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
    
    init(dependencies: AppDependencies) {
        catalogue = dependencies.catalogue
        rateService = dependencies.makeRateService()
        preferences = dependencies.preferences
        favorites = dependencies.favorites
        statistics = dependencies.statistics
        mistakes = dependencies.mistakes
        
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
        [demoService.items.count, catalogue.allVerbs.count]
    }
    
    // MARK: Services
    
    private let demoService = DemoService()
    private let languageService = LanguageService()
    private let rateService: RateService
    private let catalogue: VerbCatalogue
    private let preferences: Preferences
    private let favorites: Favorites
    private let statistics: Statistics
    private let mistakes: Mistakes
    
    // MARK: Publishers
    
    let publisher = UserDefaults.shared
        .publisher(for: \.isPaid)
    
    // MARK: Published
    
    var isPaid = FeatureToggle.isPaid
    var isShowingPaywall = false

    /// Bumped to ask the view for a haptic tap.
    private(set) var warningFeedback = 0
    
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
        warningFeedback += 1
        
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
                preferences.setAnswers(0, for: $0)
            }
        case .learnedVerbs:
            statistics.clear()
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
        let answeredCorrectlyTranslation = preferences.translationAnswers
        let answeredCorrectlyWriting = preferences.writingAnswers
        let answeredCorrectlySentences = preferences.sentencesAnswers
        let answeredCorrectlyListening = preferences.listeningAnswers
        let answeredCorrectlyTotal = answeredCorrectlyTranslation +
            answeredCorrectlyWriting +
            answeredCorrectlySentences +
            answeredCorrectlyListening
        
        let learnedCount = statistics.info.filter { $0.value >= 3 }.count
        let inProgressCount = statistics.info.filter { $0.value > 0 && $0.value < 3 }.count
        let verbsCount = catalogue.allVerbs.count

        let worstVerbs = catalogue.allVerbs
            .filter { !favorites.verbs.contains($0) &&
                (mistakes.info[$0.infinitive.value] ?? 0) > 0 }
            .first(count: 5)
        
        return .init(verbsCount: verbsCount,
                     learnedWordsCount: learnedCount,
                     wordsInProgressCount: inProgressCount,
                     totalAnswersCount: answeredCorrectlyTotal,
                     translationAnswersCount: answeredCorrectlyTranslation,
                     formsAnswersCount: answeredCorrectlyWriting,
                     sentenceAnswersCount: answeredCorrectlySentences,
                     listeningAnswersCount: answeredCorrectlyListening,
                     mistakes: worstVerbs)
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
        let verbsCount = catalogue.allVerbs.count

        let worstVerbs = [catalogue.allVerbs.randomElement()].compactMap { $0 }
        
        return .init(verbsCount: verbsCount,
                     learnedWordsCount: learnedCount,
                     wordsInProgressCount: inProgressCount,
                     totalAnswersCount: answeredCorrectlyTotal,
                     translationAnswersCount: answeredCorrectlyTranslation,
                     formsAnswersCount: answeredCorrectlyWriting,
                     sentenceAnswersCount: answeredCorrectlySentences,
                     listeningAnswersCount: answeredCorrectlyListening,
                     mistakes: worstVerbs)
    }
}
