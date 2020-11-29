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
    weak var viewController: AccentColorViewController?
    
    private let accentColors = AccentColor.allCases.sorted { $0.rawValue < $1.rawValue }
    private var selectedIndexPath: IndexPath?
    
    override init() {
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
        
        dataSource.setup([Section(header: nil,
                                  items: accentColorItems),
                          Section(header: nil,
                                  items: [ActionItem(text: "Match app icon with accent color".localized,
                                                     style: .standard,
                                                     actionBlock: nil)])])
    }
}

// MARK: - UITableViewDelegate

extension AccentColorPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.selectedIndexPath = indexPath
        AccentColor.current = accentColors[indexPath.row]
        NotificationCenter.default.post(name: .paid, object: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = dataSource.selectedIndexPath {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
}
