//
//  AcknowledgementsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AcknowledgementsViewController: UIViewController {
    
    private let presenter: AcknowledgementsPresenter
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: AcknowledgementsPresenter) {
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
        setupKeyboardService()
    }
}

// MARK: - Restorable

extension AcknowledgementsViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - SettingsChildViewControllerProtocol

extension AcknowledgementsViewController: SettingsChildViewControllerProtocol {}

// MARK: - Private

private extension AcknowledgementsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = .localized(.acknowledgements)
        navigationItem.largeTitleDisplayMode = .never
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
        
        tableView.allowsSelection = false
        tableView.dataSource = presenter.dataSource
        tableView.register(PlainCell.self, RightDetailCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
}
