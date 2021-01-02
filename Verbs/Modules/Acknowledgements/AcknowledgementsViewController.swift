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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.allowsSelection = false
        tableView.dataSource = presenter.dataSource
        tableView.register(PlainCell.self, RightDetailCell.self)
        
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
}
