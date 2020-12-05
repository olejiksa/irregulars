//
//  TestDetailViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestDetailViewController: UIViewController {
    
    private let presenter: TestDetailPresenter
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: TestDetailPresenter) {
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

private extension TestDetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "ThreeFormsTitle".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let hintItem = UIBarButtonItem(image: SystemIcon.question.image,
                                       style: .plain,
                                       target: presenter,
                                       action: #selector(presenter.showHint))
        navigationItem.rightBarButtonItem = hintItem
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
        
        tableView.register(PlainDetailCell.self, InputCell.self)
        
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

extension TestDetailViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
        setupKeyboardService()
        NotificationCenter.default.post(name: .test,
                                        object: nil,
                                        userInfo: [:])
    }
}

// MARK: - UINavigationControllerDelegate

extension TestDetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        
        switch viewController {
        case is TestDetailViewController:
            NotificationCenter.default.post(name: .test,
                                            object: nil,
                                            userInfo: [:])
        case is EmptyViewController:
            NotificationCenter.default.post(name: .test,
                                            object: nil,
                                            userInfo: [:])
        default:
            break
        }
    }
}
