//
//  StatisticsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let presenter: StatisticsPresenter
    
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: StatisticsPresenter) {
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
        setupKeyboardService()
        setupDelegate()
        
        RateService().requestReviewIfAppropriate(minimumReviewWorthyActionCount: 15)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
}

// MARK: - Private

private extension StatisticsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "statistics".localized
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
        
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.register(ActionCell.self,
                           RightDetailCell.self,
                           StatisticsHeaderCell.self,
                           ProgressCell.self,
                           MistakeCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
}

// MARK: - Restorable

extension StatisticsViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
        setupKeyboardService()
    }
}

// MARK: - UINavigationControllerDelegate

extension StatisticsViewController: UINavigationControllerDelegate {
    
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
