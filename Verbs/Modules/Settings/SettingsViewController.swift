//
//  SettingsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import MessageUI
import StoreKit
import UIKit

final class SettingsViewController: UIViewController {
    
    var shouldRegularVerbsBeShownBlock: ((Bool) -> ())?
    var shouldDerivedFormsBeShownBlock: ((Bool) -> ())?

    @IBOutlet private weak var tableView: UITableView!
    
    private let userDefaultsService = UserDefaultsService()
    private var sectionNames = ["General".localized, "Links".localized]
    private var items: [[ItemProtocol]] = []
    private var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupItems()
    }
}

// MARK: - Private

private extension SettingsViewController {
    
    var isMailAvailable: Bool { MFMailComposeViewController.canSendMail() }
    
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
    
    func setupItems() {
        settings = userDefaultsService.load() ?? .init()
        items = [[DisclosureItem(text: "Language".localized,
                                 isEnabled: true,
                                 actionBlock: willShowLanguageSettings),
                  SwitchItem(text: "Regular verbs (-ed)".localized,
                             isOn: settings?.shouldRegularVerbsBeShown ?? true,
                             isEnabled: FeatureToggle.isPaid,
                             actionBlock: didRegularVerbsOptionChange),
                  SwitchItem(text: "Derived forms".localized,
                             isOn: settings?.shouldDerivedFormsBeShown ?? true,
                             isEnabled: FeatureToggle.isPaid,
                             actionBlock: didDerivedFormsOptionChange)],
                 [DisclosureItem(text: "Rate and review".localized,
                                 isEnabled: true,
                                 actionBlock: willRate),
                  DisclosureItem(text: "Contact us".localized,
                                 isEnabled: isMailAvailable,
                                 actionBlock: willMail)]]
        setupUnlockSection()
    }
    
    func setupUnlockSection() {
        guard !FeatureToggle.isPaid else { return }
        sectionNames.insert("Unlock all features".localized, at: 0)
        let nonPaidItems = [DisclosureItem(text: "Buy full version".localized,
                                           isEnabled: true,
                                           actionBlock: {}),
                            DisclosureItem(text: "Restore a purchase".localized,
                                           isEnabled: true,
                                           actionBlock: {})]
        items.insert(nonPaidItems, at: 0)
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
    
    func willMail() {
        guard
            let productName = Bundle.main.productName,
            let version = Bundle.main.releaseVersionNumber
        else { return }

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["quillaur@outlook.com"])
        mailComposerVC.setSubject("\(productName) \(version)")
        present(mailComposerVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionNames[section]
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.section][indexPath.row]
        switch item {
        case let disclosureItem as DisclosureItem:
            disclosureItem.actionBlock()
        default:
            break
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        dismiss(animated: true)
    }
}

private extension Bundle {
    
    var productName: String? { infoDictionary?["CFBundleName"] as? String }
    var releaseVersionNumber: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
}
