//
//  NotificationsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NotificationsViewController: UIViewController {
    
    private let presenter: NotificationsPresenter
    private var tableView: UITableView?
    
    init(presenter: NotificationsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupView()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}

// MARK: - Restorable

extension NotificationsViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - SettingsChildViewControllerProtocol

extension NotificationsViewController: SettingsChildViewControllerProtocol {}

// MARK: - Private

private extension NotificationsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = .localized(.notifications)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        let tableViewStyle: UITableView.Style = splitViewController?.isCollapsed == true ? .grouped : .insetGrouped
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.accessibilityIdentifier = AccessibilityIdentifier.notificationsTable.rawValue
        
        tableView.register(TimePickerCell.self,
                           SwitchCell.self,
                           RightDetailCell.self,
                           StepperCell.self,
                           PlainDetailCell.self,
                           IconDetailCell.self)
        
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
}
