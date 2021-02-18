//
//  NotificationsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NotificationsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: NotificationsRouter?
    weak var viewController: NotificationsViewController?
    
    private let notificationService: NotificationService
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
        super.init()
        subscribe()
        setupSections()
    }
}

// MARK: - Private

private extension NotificationsPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: .reload,
                                               object: nil)
    }
    
    func setupSections() {
        let notificationItem: ItemProtocol = Locator.areNotificationsAvailable ?
            SwitchItem(text: "notifications".localized,
                       isOn: UserDefaults.shared.bool(for: .notifications),
                       actionBlock: didNotificationsEnabled) :
            RightDetailItem(title: "notifications".localized,
                            subtitle: "not_allowed".localized,
                            actionBlock: willShowSystemAppSettings)
        
        var timeItems = [ItemProtocol]()
        var repetitionItems = [ItemProtocol]()
        if UserDefaults.shared.bool(for: .notifications),
           Locator.areNotificationsAvailable {
            let since = UserDefaults.shared.integer(for: .since)
            timeItems.append(IconDetailItem(icon: .sunrise,
                                            iconAccessibilityText: "sunrise".localized,
                                            text: "Когда у Вас начинается утро?".localized))
            timeItems.append(TimePickerItem(title: "since".localized,
                                            action: didSinceTimeChange,
                                            scrollingBlock: didScroll,
                                            value: since,
                                            isEnabled: true))
            let to = UserDefaults.shared.integer(for: .to)
            timeItems.append(IconDetailItem(icon: .sunset,
                                            iconAccessibilityText: "sunset".localized,
                                            text: "В каком часу Вы ложитесь спать?".localized))
            timeItems.append(TimePickerItem(title: "to".localized,
                                            action: didToTimeChange,
                                            scrollingBlock: didScroll,
                                            value: to,
                                            isEnabled: true))
            let frequency = UserDefaults.shared.integer(for: .frequency)
            repetitionItems.append(StepperItem(title: "count".localized,
                                               minimum: 1,
                                               maximum: 6,
                                               value: frequency,
                                               action: didFrequencyChange))
        }
        
        let contentItem = PlainDetailItem(text: "Настройте удобные для Вас время и частоту напоминаний слов в течение дня".localized,
                                          textStyle: .secondary)
        
        dataSource.setup([Section(items: [contentItem, notificationItem]),
                          Section(header: "time".localized, items: timeItems),
                          Section(header: "frequency".localized, items: repetitionItems)])
    }
    
    func didNotificationsEnabled(_ value: Bool) {
        value ?
            notificationService.authorize() :
            notificationService.deauthorize()
        setupSections()
        viewController?.reloadData()
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func didFrequencyChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .frequency)
        notificationService.schedule()
    }
    
    func didSinceTimeChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .since)
        notificationService.schedule()
    }
    
    func didToTimeChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .to)
        notificationService.schedule()
    }
    
    func willShowSystemAppSettings(_ sender: ItemProtocol) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        router?.open(url)
    }
    
    @objc func didPay(_ notification: Notification) {
        DispatchQueue.main.async {
            self.setupSections()
            self.viewController?.reloadData()
            self.updateNotificationsAvailability()
        }
    }
    
    func updateNotificationsAvailability() {
        notificationService.checkAvailability { [weak self] result in
            guard let self = self else { return }
            Locator.areNotificationsAvailable = result
            DispatchQueue.main.async {
                self.setupSections()
                self.viewController?.reloadData()
            }
        }
    }
    
    func didScroll(cell: UITableViewCell) {
        viewController?.scrollToBottom(cell: cell)
    }
}

// MARK: - UITableViewDelegate

extension NotificationsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let actionableItem = dataSource.item(at: indexPath) as? Actionable,
              let item = actionableItem as? ItemProtocol else { return }
        
        actionableItem.actionBlock?(item)
    }
}
