//
//  TestsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsPresenter: NSObject {
    
    weak var viewController: UIViewController?
    
    let dataSource = SectionDataSource()
    
    private let testService = TestService()
    private let items: [[String]]
    
    override init() {
        self.items = testService.items
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension TestsPresenter {
    
    func setupSections() {
        let subtitleItems = items.enumerated().map {
            SubtitleItem(title: "Level \($0.offset + 1)",
                         subtitle: $0.element.joined(separator: ", "), hasDisclosureIndicator: true)
        }
        
        dataSource.setup([Section(header: nil, items: subtitleItems)])
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < items.count else { return }
        let vc = TestDetailAssembly(items: items[indexPath.row],
                                    navigationController: viewController?.navigationController).viewController()
        viewController?.navigationController?.push(vc)
    }
}
