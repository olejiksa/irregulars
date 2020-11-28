//
//  AccentColorPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AccentColorPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    weak var viewController: AccentColorViewController?
    
    override init() {
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension AccentColorPresenter {
    
    func setupSections() {
        let accentColors = AccentColor.allCases.sorted { $0.rawValue < $1.rawValue }
        let accentColorItems = accentColors.map(AccentColorItem.init)
        
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource.item(at: indexPath)
        switch item {
        case let accentColorItem as AccentColorItem:
            accentColorItem.isSelected = true
            viewController?.reloadData()
        default:
            break
        }
    }
}
