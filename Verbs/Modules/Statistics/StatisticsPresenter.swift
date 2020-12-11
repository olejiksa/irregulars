//
//  StatisticsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    weak var viewController: StatisticsViewController?
    
    private var items: [String] = []
    
    override init() {
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension StatisticsPresenter {
    
    func setupSections() {
        
    }
    
}

// MARK: - UITableViewDelegate

extension StatisticsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
