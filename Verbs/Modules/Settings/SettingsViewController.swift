//
//  SettingsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import StoreKit
import UIKit

final class SettingsViewController: UIViewController {
    
    var shouldRegularVerbsBeShownBlock: ((Bool) -> ())?
    var shouldDerivedFormsBeShownBlock: ((Bool) -> ())?

    @IBOutlet private weak var tableView: UITableView!
    
    private let mailService = MailService()
    private let userDefaultsService = UserDefaultsService()
    private var sections: [Section] = []
    private var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupSettings()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Settings".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseTap))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupTableView() {
        tableView.register(SwitchCell.self, DisclosureCell.self)
    }
    
    func setupSettings() {
        settings = userDefaultsService.load() ?? .init()
    }
    
    func setupItems() {
        sections = [Section(header: "Unlock all features".localized,
                            items: [DisclosureItem(text: "Buy full version".localized,
                                                   isEnabled: true,
                                                   actionBlock: {}),
                                    DisclosureItem(text: "Restore a purchase".localized,
                                                   isEnabled: true,
                                                   actionBlock: {})].filter { _ in !FeatureToggle.isPaid }),
                    Section(header: "General".localized,
                            items: [DisclosureItem(text: "Language".localized,
                                                   isEnabled: true,
                                                   actionBlock: willShowLanguageSettings),
                                    SwitchItem(text: "Regular verbs (-ed)".localized,
                                               isOn: settings?.shouldRegularVerbsBeShown ?? true,
                                               isEnabled: FeatureToggle.isPaid,
                                               actionBlock: didRegularVerbsOptionChange),
                                    SwitchItem(text: "Derived forms".localized,
                                               isOn: settings?.shouldDerivedFormsBeShown ?? true,
                                               isEnabled: FeatureToggle.isPaid,
                                               actionBlock: didDerivedFormsOptionChange)]),
                    Section(header: "Links".localized,
                            items: [DisclosureItem(text: "Rate and review".localized,
                                                   isEnabled: true,
                                                   actionBlock: willRate),
                                    DisclosureItem(text: "Contact us".localized,
                                                   isEnabled: mailService.isMailAvailable,
                                                   actionBlock: { [weak self] in self?.mailService.present(in: self) })])]
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
    
    func didRegularVerbsOptionChange(_ value: Bool) {
        settings?.shouldRegularVerbsBeShown = value
        userDefaultsService.save(settings)
        shouldRegularVerbsBeShownBlock?(value)
    }
    
    func didDerivedFormsOptionChange(_ value: Bool) {
        settings?.shouldDerivedFormsBeShown = value
        userDefaultsService.save(settings)
        shouldDerivedFormsBeShownBlock?(value)
    }
    
    func willShowLanguageSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func willRate() {
        let scenes = UIApplication.shared.connectedScenes
        
        guard
            let scene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
        
        SKStoreReviewController.requestReview(in: scene)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case let disclosureItem as DisclosureItem:
            disclosureItem.actionBlock()
        default:
            break
        }
    }
}
