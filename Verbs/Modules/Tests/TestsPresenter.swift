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
                       subtitle: "translation_subtitle".localized,
                       test: .translation)
            : nil
        
        let items = [translationItem,
                     TestItem(icon: .pencil,
                              title: Test.writing.title,
                              subtitle: "writing_subtitle".localized,
                              test: .writing),
                     TestItem(icon: .sentences,
                              title: Test.sentences.title,
                              subtitle: "sentences_subtitle".localized,
                              test: .sentences),
                     TestItem(icon: .headphones,
                              title: Test.listening.title,
                              subtitle: "listening_subtitle".localized,
                              test: .listening),
                     TestItem(icon: .chart,
                              title: "statistics".localized,
                              subtitle: "track_your_progress_in_learning_irregular_verbs".localized,
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
                                               name: .test,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: .reload,
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
