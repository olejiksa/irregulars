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
    var router: StatisticsRouter?
    weak var viewController: StatisticsViewController?
    
    private let languageService: LanguageService
    private let hapticService: HapticService
    private let verbsService: VerbsService
    
    private var items: [String] = []
    private let keys: [UserDefaults.Key] = [.translationAnswers,
                                            .writingAnswers,
                                            .sentencesAnswers,
                                            .listeningAnswers]
    
    init(languageService: LanguageService,
         hapticService: HapticService,
         verbsService: VerbsService) {
        self.languageService = languageService
        self.hapticService = hapticService
        self.verbsService = verbsService
        super.init()
        setupSections()
        subscribe()
    }
}

// MARK: - Private

private extension StatisticsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: .reload,
                                               object: nil)
    }
    
    func setupSections() {
//        #if DEBUG
//        let statisticsModel = prepareUITestsStatisticsModel()
//        #else
        let statisticsModel = prepareStatisticsModel()
//        #endif
        
        let answeredCorrectlyString = String(format: "answered_correctly_count".localized,
                                             statisticsModel.totalAnswersCount)
        
        let hasTranslation = languageService.hasTranslation ?
            RightDetailItem(title: Test.translation.title,
                            subtitle: String(statisticsModel.translationAnswersCount)) : nil
        
        let mistakeItems = statisticsModel.mistakes.map { verb in MistakeItem(verb: verb) { isFavorite in
            if isFavorite {
                Locator.favorites.add(verb)
                Locator.mistakes.remove(verb)
            } else {
                Locator.favorites.remove(verb)
                Locator.mistakes.add(verb)
            }
        }}
        
        dataSource.setup([setupActivationSection(upgradeBlock: willBuy),
                          TableViewSection(header: "learned_verbs".localized,
                                  items: [ProgressItem(value: statisticsModel.learnedWordsCount,
                                                       maximum: statisticsModel.verbsCount)],
                                  footer: "learned_verbs_footer".localized),
                          TableViewSection(header: "in_progress".localized,
                                  items: [ProgressItem(value: statisticsModel.wordsInProgressCount,
                                                       maximum: statisticsModel.verbsCount - statisticsModel.learnedWordsCount)]),
                          TableViewSection(header: "frequent_mistakes".localized,
                                  items: mistakeItems,
                                  footer: "frequent_mistakes_footer".localized),
                          TableViewSection(header: "your_efforts".localized,
                                  items: [StatisticsHeaderItem(title: String(statisticsModel.totalAnswersCount),
                                                               subtitle: answeredCorrectlyString)],
                                  footer: "using_hints_gives_you_no_points".localized),
                          TableViewSection(header: "including".localized,
                                  items: [hasTranslation,
                                          RightDetailItem(title: Test.writing.title,
                                                          subtitle: String(statisticsModel.formsAnswersCount)),
                                          RightDetailItem(title: Test.sentences.title,
                                                          subtitle: String(statisticsModel.sentenceAnswersCount)),
                                          RightDetailItem(title: Test.listening.title,
                                                          subtitle: String(statisticsModel.listeningAnswersCount))]
                                    .compactMap { $0 }),
                          TableViewSection(header: "reset".localized,
                                  items: [ActionItem(text: "erase_learned_verbs".localized,
                                                     style: .destructive,
                                                     actionBlock: didResetTap),
                                          ActionItem(text: "erase_correct_answers".localized,
                                                     style: .destructive,
                                                     actionBlock: didResetTap)])])
    }
    
    func setupActivationSection(upgradeBlock: @escaping ItemBlock) -> TableViewSection {
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "upgrade_to_pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let footer = "pro_suggestion_statistics".localized(with: [DemoService().items.count,
                                                                  verbsService.items.count])
        return TableViewSection(header: "activation".localized,
                       items: [upgradeItem].compactMap { $0 },
                       footer: footer)
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
    
    func willBuy(_ sender: ItemProtocol) {
        router?.goToPaywall()
    }
    
    func didResetTap(_ sender: ItemProtocol) {
        guard let actionItem = sender as? ActionItem else { return }
        
        let statisticsKind: StatisticsKind
        switch actionItem.text {
        case "erase_learned_verbs".localized:
            statisticsKind = .learnedVerbs
        case "erase_correct_answers".localized:
            statisticsKind = .correctAnswers
        default:
            statisticsKind = .correctAnswers
        }
        
        hapticService.generateHapticFeedback(for: .notification(.warning))
        router?.reset(statisticsKind: statisticsKind) { [weak self] in
            guard let self = self else { return }
            
            switch statisticsKind {
            case .learnedVerbs:
                Locator.statistics.clear()
            case .correctAnswers:
                [.translationAnswers,
                 .writingAnswers,
                 .sentencesAnswers,
                 .listeningAnswers].forEach { UserDefaults.shared.set(0, for: $0) }
            }
            
            self.setupSections()
            self.viewController?.reloadData()
        }
    }
    
    @objc func didPay(_ notification: Notification) {
        setupSections()
        viewController?.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension StatisticsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let actionableItem = dataSource.item(at: indexPath) as? Actionable,
           let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}
