//
//  SentenceViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SentenceViewController: UIViewController {
    
    private let presenter: SentencePresenter
    private var tableView: UITableView?

    init(presenter: SentencePresenter) {
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
        setupDelegate()
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
}

// MARK: - Private

private extension SentenceViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "SentenceTitle".localized
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
        
        tableView.register(InputCell.self, PlainDetailCell.self)
        
        self.tableView = tableView
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
}

// MARK: - Restorable

extension SentenceViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - UINavigationControllerDelegate

extension SentenceViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        
        if viewController is EmptyViewController {
            NotificationCenter.default.post(name: .test,
                                            object: nil,
                                            userInfo: [:])
        }
    }
}
