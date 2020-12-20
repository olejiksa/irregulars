//
//  TestsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsPresenter: NSObject {
    
    var router: TestsRouter?
    weak var viewController: TestsViewController?
    
    let dataSource = SectionDataSource()
    
    private let languageService: LanguageService
    private var selectedIndex: IndexPath?
    
    init(languageService: LanguageService) {
        self.languageService = languageService
        super.init()
        subscribe()
    }
    
    func setupSections() {
        let translationItem = languageService.hasTranslation
            ? TestItem(icon: .globe,
                       title: Test.translation.title,
                       subtitle: "TranslationSubtitle".localized,
                       test: .translation)
            : nil
        
        let items = [translationItem,
                     TestItem(icon: .pencil,
                              title: Test.writing.title,
                              subtitle: "WritingSubtitle".localized,
                              test: .writing),
                     TestItem(icon: .sentences,
                              title: Test.sentences.title,
                              subtitle: "SentenceSubtitle".localized,
                              test: .sentences),
                     TestItem(icon: .headphones,
                              title: Test.listening.title,
                              subtitle: "ListeningSubtitle".localized,
                              test: .listening),
//                     TestItem(icon: .mic,
//                              title: Test.speaking.title,
//                              subtitle: "SpeakingSubtitle".localized,
//                              test: .speaking),
                     TestItem(icon: .chart,
                              title: "Statistics".localized,
                              subtitle: "Track your progress in learning irregular verbs".localized,
                              test: nil)
        ].compactMap { $0 }
        dataSource.setup([Section(items: items)])
    }
}

// MARK: - Private

private extension TestsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemReset),
                                               name: Notification.Name.test,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    @objc func didSelectedItemReset(_ notification: Notification) {
        selectedIndex = nil
    }
    
    @objc func didPay(_ notification: Notification) {
        viewController?.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath != selectedIndex else { return }
        
        let item = dataSource.item(at: indexPath) as? TestItem
        if let test = item?.test {
            router?.goTo(test: test)
        } else {
            router?.goToStatistics()
        }
        
        selectedIndex = indexPath
    }
}
