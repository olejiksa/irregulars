//
//  SettingsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    var shouldRegularVerbsBeShownBlock: ((Bool) -> ())?
    var shouldDerivedFormsBeShownBlock: ((Bool) -> ())?

    @IBOutlet private weak var tableView: UITableView!
    
    private let userDefaultsService = UserDefaultsService()
    private var items: [ItemProtocol] = []
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
    
    func setupNavigationBar() {
        navigationItem.title = "Settings".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseTap))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupTableView() {
        tableView.register(SwitchCell.self)
    }
    
    func setupItems() {
        settings = userDefaultsService.load() ?? .init()
        items = [SwitchItem(text: "Regular verbs (-ed)".localized,
                            isOn: settings?.shouldRegularVerbsBeShown ?? true,
                            actionBlock: didRegularVerbsOptionChange),
                 SwitchItem(text: "Derived forms".localized,
                            isOn: settings?.shouldDerivedFormsBeShown ?? true,
                            actionBlock: didDerivedFormsOptionChange)]
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
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(for: items[indexPath.row], at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "General".localized
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
