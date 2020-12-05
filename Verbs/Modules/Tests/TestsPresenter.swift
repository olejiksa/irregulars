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
        let items = [TestItem(icon: .letters,
                              title: "ThreeFormsTitle".localized,
                              subtitle: "ThreeFormsSubtitle".localized),
                     TestItem(icon: .sentences,
                              title: "SentenceTitle".localized,
                              subtitle: "SentenceSubtitle".localized)
        ]
        dataSource.setup([Section(items: items)])
    }
    
    func selectWhenRegular() {
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard viewController?.splitViewController?.secondaryViewController?.topViewController as? TestDetailViewController != nil else { return }
        viewController?.selectSection(at: nil)
    }
}

// MARK: - Private

private extension TestsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemUpdate),
                                               name: Notification.Name.test,
                                               object: nil)
    }
    
    @objc func didSelectedItemUpdate(_ notification: Notification) {
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        let test = notification.userInfo?[Notification.Name.test] as? Test
        selectedIndex = test?.indexPath
        viewController?.selectSection(at: selectedIndex)
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        switch indexPath.row {
        case 0: router?.goToThreeForms()
        case 1: router?.goToSentence()
        default: break
        }
        
        viewController?.selectSection(at: selectedIndex)
    }
}
