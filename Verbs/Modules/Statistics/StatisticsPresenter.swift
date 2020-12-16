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
    private var items: [String] = []
    private let keys: [UserDefaults.Key] = [.translationAnswers,
                                            .writingAnswers,
                                            .sentencesAnswers,
                                            .listeningAnswers]
    
    init(languageService: LanguageService) {
        self.languageService = languageService
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
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func setupSections() {
        let answeredCorrectlyTranslation = UserDefaults.shared.integer(for: .translationAnswers)
        let answeredCorrectlyWriting = UserDefaults.shared.integer(for: .writingAnswers)
        let answeredCorrectlySentences = UserDefaults.shared.integer(for: .sentencesAnswers)
        let answeredCorrectlyListening = UserDefaults.shared.integer(for: .listeningAnswers)
        let answeredCorrectlyTotal = answeredCorrectlyTranslation +
            answeredCorrectlyWriting +
            answeredCorrectlySentences +
            answeredCorrectlyListening
        let answeredCorrectlyString = String(format: "answeredCorrectlyCount".localized,
                                             answeredCorrectlyTotal)
        
        let hasTranslation = languageService.hasTranslation ?
            RightDetailItem(title: Test.translation.title,
                            subtitle: String(answeredCorrectlyTranslation),
                            isEnabled: false) :
            nil
        
        dataSource.setup([setupActivationSection(upgradeBlock: willBuy),
                          Section(items: [StatisticsHeaderItem(title: String(answeredCorrectlyTotal),
                                                               subtitle: answeredCorrectlyString)],
                                  footer: "Using hints gives you no points".localized),
                          Section(header: "Of them".localized,
                                  items: [hasTranslation,
                                          RightDetailItem(title: Test.writing.title,
                                                          subtitle: String(answeredCorrectlyWriting),
                                                          isEnabled: false),
                                          RightDetailItem(title: Test.sentences.title,
                                                          subtitle: String(answeredCorrectlySentences),
                                                          isEnabled: false),
                                          RightDetailItem(title: Test.listening.title,
                                                          subtitle: String(answeredCorrectlyListening),
                                                          isEnabled: false)].compactMap { $0 }),
                          Section(items: [ActionItem(text: "Reset statistics".localized,
                                                     style: .standard,
                                                     actionBlock: didResetTap)])])
    }
    
    func setupActivationSection(upgradeBlock: @escaping ItemBlock) -> Section {
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "Upgrade to Pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let footer = "ProSuggestionStatistics".localized(with: [DemoService().items.count,
                                                                VerbsService().items.count])
        return Section(header: "Activation".localized,
                       items: [upgradeItem].compactMap { $0 },
                       footer: footer)
    }
    
    func willBuy(_ sender: ItemProtocol) {
        router?.goToPaywall()
    }
    
    func didResetTap(_ sender: ItemProtocol) {
        router?.reset() { [weak self] in
            guard let self = self else { return }
            
            self.keys.forEach { UserDefaults.shared.set(0, for: $0) }
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
