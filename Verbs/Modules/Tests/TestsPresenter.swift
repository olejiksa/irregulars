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
    
    private var selectedIndex: IndexPath?
    
    override init() {
        super.init()
        subscribe()
    }
    
    func setupSections() {
        let languageService = LanguageService()
        let translationItem = languageService.hasTranslation ?
            TestItem(icon: .globe, title: Test.translation.title, subtitle: "TranslationSubtitle".localized) :
            nil
        
        let items = [translationItem,
                     TestItem(icon: .pencil,
                              title: Test.writing.title,
                              subtitle: "ThreeFormsSubtitle".localized),
                     TestItem(icon: .sentences,
                              title: Test.sentences.title,
                              subtitle: "SentenceSubtitle".localized),
                     TestItem(icon: .headphones,
                              title: Test.listening.title,
                              subtitle: "ListeningSubtitle".localized),
                     TestItem(icon: .chart,
                              title: "Statistics".localized,
                              subtitle: "Track your progress in learning irregular verbs".localized)
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
    }
    
    @objc func didSelectedItemReset(_ notification: Notification) {
        selectedIndex = nil
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath != selectedIndex else { return }
        
        if UserDefaults.shared.bool(for: .favoritesOnly),
           Locator.favorites.verbs.isEmpty,
           0...3 ~= indexPath.row {
            router?.showEmptyFavorites()
            return
        }
        
        let languageService = LanguageService()
        let index = languageService.hasTranslation ? indexPath.row : indexPath.row + 1
        
        switch index {
        case 0: router?.goTo(test: .translation)
        case 1: router?.goTo(test: .writing)
        case 2: router?.goTo(test: .sentences)
        case 3: router?.goTo(test: .listening)
        case 4: router?.goToStatistics()
        default: break
        }
        
        selectedIndex = indexPath
    }
}
