//
//  AccentColorViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AccentColorViewController: UIViewController {
    
    private let presenter: AccentColorPresenter
    private var tableView: UITableView?
    
    init(presenter: AccentColorPresenter) {
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
}

// MARK: - Restorable

extension AccentColorViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - Private

private extension AccentColorViewController {
    
    func setupNavigationBar() {
        navigationItem.title = .localized(.accentColor)
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
        
        tableView.accessibilityIdentifier = AccessibilityIdentifier.accentColorTable.rawValue
        
        tableView.register(ActionCell.self, AccentColorCell.self)
        
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
}
