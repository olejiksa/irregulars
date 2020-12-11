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
        let answeredCorrectlyBasic = UserDefaults.standard.integer(for: .answeredCorrectlyBasic)
        let answeredCorrectlyAdvanced = UserDefaults.standard.integer(for: .answeredCorrectlyAdvanced)
        let answeredCorrectlyTotal = answeredCorrectlyBasic + answeredCorrectlyAdvanced
        let answeredCorrectlyString = String(format: "answeredCorrectlyCount".localized,
                                             answeredCorrectlyTotal)
        
        dataSource.setup([Section(items: [StatisticsHeaderItem(title: String(answeredCorrectlyTotal),
                                                               subtitle: answeredCorrectlyString)]),
                          Section(header: "Basic tests".localized,
                                  items: [RightDetailItem(title: "Answered correctly".localized,
                                                          subtitle: String(answeredCorrectlyBasic),
                                                          isEnabled: false)]),
                          Section(header: "Advanced tests".localized,
                                  items: [RightDetailItem(title: "Answered correctly".localized,
                                                          subtitle: String(answeredCorrectlyAdvanced),
                                                          isEnabled: false)]),
                          Section(items: [ActionItem(text: "Reset statistics".localized,
                                                     style: .standard,
                                                     actionBlock: didResetTap)])])
    }
    
    func didResetTap(_ sender: ItemProtocol) {
        UserDefaults.standard.set(0, for: .answeredCorrectlyBasic)
        UserDefaults.standard.set(0, for: .answeredCorrectlyAdvanced)
        setupSections()
        viewController?.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension StatisticsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let actionableItem = dataSource.item(at: indexPath) as? Actionable,
           let item = actionableItem as? ItemProtocol {
            actionableItem.actionBlock?(item)
        }
    }
}
