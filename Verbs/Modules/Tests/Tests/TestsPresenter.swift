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
    private let hapticService: HapticService
    private var selectedIndex: IndexPath?
    
    init(languageService: LanguageService,
         hapticService: HapticService) {
        self.languageService = languageService
        self.hapticService = hapticService
        super.init()
        subscribe()
    }
    
    func setupSections() {
        let translationItem = languageService.hasTranslation
            ? TestItem(icon: .globe,
                       test: .translation,
                       accessibilityIdentifier: nil)
            : nil
        
        let items = [translationItem,
                     TestItem(icon: .pencil,
                              test: .writing),
                     TestItem(icon: .sentences,
                              test: .sentences),
                     TestItem(icon: .headphones,
                              test: .listening),
                     TestItem(icon: .mic,
                              test: .speaking),
                     TestItem(icon: .chart,
                              title: "statistics".localized,
                              subtitle: "track_your_progress_in_learning_irregular_verbs".localized)
        ].compactMap { $0 }
        dataSource.setup([TableViewSection(items: items)])
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
        
        let item = dataSource.item(at: indexPath) as? TestItem
        if let test = item?.test {
            if UserDefaults.shared.bool(for: .favoritesOnly),
               Locator.favorites.verbs.isEmpty {
                hapticService.generateHapticFeedback(for: .notification(.error))
                router?.showEmptyFavorites()
                return
            }
            
            guard indexPath != selectedIndex else { return }
            router?.goTo(test: test)
        } else {
            guard indexPath != selectedIndex else { return }
            router?.goToStatistics()
        }
        
        selectedIndex = indexPath
    }
}
