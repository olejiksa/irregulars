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

    @IBOutlet private weak var tableView: UITableView!
    
    private let userDefaultsService = UserDefaultsService()
    private var items: [ItemProtocol] = []
    
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
        navigationItem.title = "Settings"
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
        let isOn = userDefaultsService.load()?.isOn ?? true
        items = [SwitchItem(text: "Regular verbs (-ed)",
                            isOn: isOn,
                            actionBlock: didSwitchValueChange)]
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
    
    func didSwitchValueChange(isOn: Bool) {
        userDefaultsService.save(Settings(isOn: isOn))
        shouldRegularVerbsBeShownBlock?(isOn)
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
        "General"
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
