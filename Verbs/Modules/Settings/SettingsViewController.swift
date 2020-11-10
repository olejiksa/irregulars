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
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    private var tableView: UITableView?
    
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
        tableView?.reloadData()
    }
}

// MARK: - Private

private extension SettingsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Settings".localized
        navigationItem.largeTitleDisplayMode = .never

        if splitViewController == nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                              target: self,
                                              action: #selector(didCloseTap))
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    func setupTableView() {
        let tableViewStyle: UITableView.Style = splitViewController?.isCollapsed == true ? .grouped : .insetGrouped
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let keyboardHeightLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardHeightLayoutConstraint
        ])
        
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.register(SwitchCell.self,
                           DisclosureCell.self,
                           RightDetailCell.self,
                           ActionCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
}

// MARK: - Scrollable

extension SettingsViewController: Scrollable {
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
