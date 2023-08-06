//
//  StatisticsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    
    private let languageService: LanguageService
    private let hapticService: HapticService
    private let verbsService: VerbsService
    
    private var items: [String] = []
    
    init(languageService: LanguageService,
         hapticService: HapticService,
         verbsService: VerbsService) {
        self.languageService = languageService
        self.hapticService = hapticService
        self.verbsService = verbsService
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension StatisticsPresenter {
    
    func setupSections() {
        let statisticsModel = prepareStatisticsModel()
        
        let mistakeItems = statisticsModel.mistakes.map { verb in MistakeItem(verb: verb) { isFavorite in
            if isFavorite {
                Locator.favorites.add(verb)
                Locator.mistakes.remove(verb)
            } else {
                Locator.favorites.remove(verb)
                Locator.mistakes.add(verb)
            }
        }}
        
        dataSource.setup([TableViewSection(header: "frequent_mistakes".localized,
                                  items: mistakeItems,
                                  footer: "frequent_mistakes_footer".localized)])
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
    
    func willBuy(_ sender: ItemProtocol) {
        
    }
    
    func didResetTap(_ sender: ItemProtocol) {
        
    }
    
    @objc func didPay(_ notification: Notification) {
        setupSections()
    }
}
