//
//  TestsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsViewController: UIViewController {
    
    private let presenter: TestsPresenter
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: TestsPresenter) {
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
        setupView()
        setupSections()
        setupKeyboardService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectWhenCompact()
        guard animated else { return }
        NotificationCenter.default.post(name: .test,
                                        object: nil,
                                        userInfo: nil)
    }
    
    func selectSection(at index: Int?) {
        guard let index = index else {
            if let indexPath = tableView?.indexPathForSelectedRow {
                tableView?.deselectRow(at: indexPath, animated: true)
            }
            
            return
        }
        
        tableView?.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }
    
    func deselectWhenCompact() {
        guard splitViewController?.isCollapsed == true,
              let indexPath = tableView?.indexPathForSelectedRow else { return }
        tableView?.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private

private extension TestsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Tests".localized
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        let tableViewStyle: UITableView.Style = splitViewController?.isCollapsed == true ? .plain : .insetGrouped
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
        
        tableView.register(PlainCell.self, SubtitleCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupSections() {
        presenter.setupSections()
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
}
