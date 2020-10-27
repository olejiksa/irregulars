//
//  SettingsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let presenter: SettingsPresenter
    private var keyboardService: KeyboardService?

    @IBOutlet private weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupKeyboardService()
    }
    
    func reloadData() {
        tableView.reloadData()
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
        tableView.dataSource = presenter
        tableView.delegate = presenter
        tableView.register(SwitchCell.self, DisclosureCell.self, RightDetailCell.self)
    }
    
    func setupKeyboardService() {
        guard UIDevice.current.userInterfaceIdiom != .pad else { return }
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
}
