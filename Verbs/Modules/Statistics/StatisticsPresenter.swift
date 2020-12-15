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
    var router: StatisticsRouter?
    weak var viewController: StatisticsViewController?
    
    private var items: [String] = []
    
    override init() {
        super.init()
        setupSections()
        subscribe()
    }
}

// MARK: - Private

private extension StatisticsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func setupSections() {
        let answeredCorrectlyBasic = UserDefaults.standard.integer(for: .answeredCorrectlyBasic)
        let answeredCorrectlyAdvanced = UserDefaults.standard.integer(for: .answeredCorrectlyAdvanced)
        let answeredCorrectlyTotal = answeredCorrectlyBasic + answeredCorrectlyAdvanced
        let answeredCorrectlyString = String(format: "answeredCorrectlyCount".localized,
                                             answeredCorrectlyTotal)
        
        dataSource.setup([setupActivationSection(upgradeBlock: willBuy),
                          Section(items: [StatisticsHeaderItem(title: String(answeredCorrectlyTotal),
                                                               subtitle: answeredCorrectlyString)],
                                  footer: "Using hints gives you no points".localized),
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
    
    func setupActivationSection(upgradeBlock: @escaping ItemBlock) -> Section {
        let upgradeItem = !FeatureToggle.isPaid ? ActionItem(text: "Upgrade to Pro".localized,
                                                             style: .standard,
                                                             actionBlock: upgradeBlock) : nil
        let footer = "ProSuggestionStatistics".localized(with: [DemoService().items.count,
                                                                VerbsService().items.count])
        return Section(header: "Activation".localized,
                       items: [upgradeItem].compactMap { $0 },
                       footer: footer)
    }
    
    func willBuy(_ sender: ItemProtocol) {
        router?.goToPaywall()
    }
    
    func didResetTap(_ sender: ItemProtocol) {
        router?.reset() { [weak self] in
            guard let self = self else { return }
            
            UserDefaults.standard.set(0, for: .answeredCorrectlyBasic)
            UserDefaults.standard.set(0, for: .answeredCorrectlyAdvanced)
            self.setupSections()
            self.viewController?.reloadData()
        }
    }
    
    @objc func didPay(_ notification: Notification) {
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
