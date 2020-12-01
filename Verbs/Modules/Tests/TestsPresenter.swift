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
    
    private var selectedIndex: IndexPath?
    
    override init() {
        self.items = testService.items
        super.init()
        subscribe()
    }
    
    func setupSections() {
        let isCollapsed = viewController?.splitViewController?.isCollapsed == true
        let hasDisclosureIndicator = FeatureToggle.isPaid && isCollapsed
        // let passedLevelsCount = UserDefaults.standard.integer(for: .passed)
        let levels = items.enumerated().map(item)
        let more = [PlainItem(title: "Favorites".localized,
                              hasDisclosureIndicator: hasDisclosureIndicator)]
        // let passedLevels = items.enumerated().filter { $0.offset < passedLevelsCount }.map(item)
        
        dataSource.setup([Section(header: "General".localized, items: more),
                          Section(header: "Levels".localized, items: levels)])
    }
    
    func selectWhenRegular() {
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard let vc = viewController?.splitViewController?.secondaryViewController?.topViewController as? TestDetailViewController else { return }
        viewController?.selectSection(at: vc.test.indexPath)
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
    
    func item(for level: (offset: Int, element: [String])) -> ItemProtocol {
        let title = "\("Level".localized) \(level.offset + 1)"
        let isAvailable = level.offset < 2 || FeatureToggle.isPaid
        let isCollapsed = viewController?.splitViewController?.isCollapsed == true
        return !isCollapsed ?
            PlainItem(title: title) :
            SubtitleItem(title: title,
                         subtitle: level.element.joined(separator: ", "),
                         hasDisclosureIndicator: isAvailable && isCollapsed)
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
        let isCollapsed = viewController?.splitViewController?.isCollapsed ?? false
        guard indexPath != selectedIndex || isCollapsed else { return }
        guard indexPath.section == 1 && indexPath.row < 2 || FeatureToggle.isPaid else {
            if selectedIndex != nil, !isCollapsed {
                tableView.selectRow(at: selectedIndex,
                                    animated: true,
                                    scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            router?.goToPaywall()
            return
        }
        
        switch indexPath.section {
        case 1:
            router?.goToDetail(test: .level(indexPath.row), items: items[indexPath.row])
        case 0:
            if Locator.favorites.verbs.isEmpty {
                router?.showErrorAlert()
                viewController?.selectSection(at: selectedIndex)
            } else {
                selectedIndex = indexPath
                router?.goToDetail(test: .favorites, items: Locator.favorites.verbs.map { $0.infinitive.value })
            }
        default:
            break
        }
    }
}
