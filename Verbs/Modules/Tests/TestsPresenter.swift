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
    
    private let testService = TestService()
    private let items: [[String]]
    
    private var selectedIndex: Int?
    
    override init() {
        self.items = testService.items
        super.init()
        subscribe()
    }
    
    func setupSections() {
        let levels = items.enumerated().map { item -> SubtitleItem in
            let isAvailable = item.offset < 2 || FeatureToggle.isPaid
            let hasDisclosureIndicator = isAvailable && viewController?.splitViewController?.isCollapsed == true
            return SubtitleItem(title: "\("Level".localized) \(item.offset + 1)",
                                subtitle: item.element.joined(separator: ", "),
                                hasDisclosureIndicator: hasDisclosureIndicator)
        }
        
        dataSource.setup([Section(header: "Levels".localized, items: levels)])
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
        selectedIndex = notification.userInfo?[Notification.Name.test] as? Int ?? -1
        viewController?.selectSection(at: selectedIndex)
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != selectedIndex, indexPath.row < items.count else { return }
        guard indexPath.row < 2 || FeatureToggle.isPaid else {
            if let selectedIndex = selectedIndex {
                tableView.selectRow(at: .init(row: selectedIndex, section: 0),
                                    animated: true,
                                    scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            router?.goToPaywall()
            return
        }
        
        router?.goToDetail(index: indexPath.row, items: items[indexPath.row])
        selectedIndex = indexPath.row
    }
}
