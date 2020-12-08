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
        let items = [TestItem(icon: .studentdesk,
                              title: "ThreeFormsTitle".localized,
                              subtitle: "ThreeFormsSubtitle".localized),
                     TestItem(icon: .graduationcap,
                              title: "SentenceTitle".localized,
                              subtitle: "SentenceSubtitle".localized),
//                     TestItem(icon: .mouth,
//                              title: "Pronunciation".localized,
//                              subtitle: "SentenceSubtitle".localized),
//                     TestItem(icon: .chart,
//                              title: "Statistics".localized,
//                              subtitle: "SentenceSubtitle".localized)
        ]
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
        
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        switch indexPath.row {
        case 0: router?.goToThreeForms()
        case 1: router?.goToSentence()
        default: break
        }
        
        selectedIndex = indexPath
    }
}
