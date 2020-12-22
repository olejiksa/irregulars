//
//  AccentColorPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AccentColorPresenter: NSObject {
    
    let dataSource = SelectableSectionDataSource()
    var router: AccentColorRouter?
    weak var viewController: AccentColorViewController?
    
    private let appIconService: AppIconService
    private let accentColors = AccentColor.allCases.sorted { $0.rawValue < $1.rawValue }
    
    init(appIconService: AppIconService) {
        self.appIconService = appIconService
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension AccentColorPresenter {
    
    func setupSections() {
        let accentColorItems = accentColors.map(AccentColorItem.init)
        let index = accentColors.firstIndex { $0 == AccentColor.current } ?? 0
        dataSource.selectedIndexPath = IndexPath(row: index, section: 0)
        
        dataSource.setup([Section(items: accentColorItems),
                          Section(items: [ActionItem(text: "match_app_icon_with_accent_color".localized,
                                                     style: .standard,
                                                     actionBlock: nil)])])
    }
}

// MARK: - UITableViewDelegate

extension AccentColorPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard dataSource.selectedIndexPath != indexPath else { return }
        
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        guard indexPath.section == 0 else {
            appIconService.setIcon(for: AccentColor.current)
            return
        }
        
        dataSource.selectedIndexPath = indexPath
        AccentColor.current = accentColors[indexPath.row]
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        
        RateService().requestReviewIfAppropriate(minimumReviewWorthyActionCount: 20)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard FeatureToggle.isPaid, indexPath.section == 0 else { return indexPath }
        
        if let oldIndex = dataSource.selectedIndexPath {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
}
