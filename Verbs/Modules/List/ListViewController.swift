//
//  ListViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    private let presenter: ListPresenter
    private let searchController = UISearchController(searchResultsController: nil)
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    private var tableView: UITableView?
    private var moreButton: UIBarButtonItem?
    private var listMenu: ListMenu?
    
    private var topInset: CGFloat = 0
    
    init(presenter: ListPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupMenu()
        setupTableView()
        setupSearchController()
        setupKeyboardService()
        presenter.selectWhenRegular()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topInset = -(tableView?.safeAreaInsets.top ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.sizeToFit()
        deselectWhenCompact()
        guard animated else { return }
        NotificationCenter.default.post(name: .infinitive,
                                        object: nil,
                                        userInfo: [Notification.Name.infinitive: ""])
    }
    
    func reloadData() {
        listMenu?.build()
        tableView?.reloadData()
    }
    
    func getPaid() {
        reloadData()
        setupSearchController()
    }
    
    func selectRow(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            if let indexPathForSelectedRow = tableView?.indexPathForSelectedRow {
                tableView?.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
            
            return
        }
        
        tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    func deselectWhenCompact() {
        guard splitViewController?.isCollapsed == true,
              let indexPath = tableView?.indexPathForSelectedRow else { return }
        tableView?.deselectRow(at: indexPath, animated: true)
    }
    
    func search(text: String) {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.text = text
        presenter.updateSearchResults(for: searchController)
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupNavigationBar() {
        if splitViewController?.isCollapsed == true {
            navigationItem.title = "verbs".localized
        } else {
            navigationItem.title = "all".localized
        }
        
        moreButton = .init(image: SystemIcon.ellipsis.image,
                           style: .plain,
                           target: nil,
                           action: nil)
        navigationItem.rightBarButtonItem = moreButton
    }
    
    func setupMenu() {
        listMenu = .init(barButtonItem: moreButton,
                         paywallBlock: presenter.router?.goToPaywall,
                         updateDerivativesBlock: presenter.updateDerivatives,
                         updateRegularsBlock: presenter.updateRegulars)
        listMenu?.build()
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
        
        tableView.dataSource = presenter
        tableView.delegate = presenter
        tableView.dragDelegate = presenter
        
        tableView.register(ListCell.self, SubtitleCell.self)
        tableView.tableFooterView = UIView()
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupSearchController() {
        searchController.delegate = presenter
        searchController.searchResultsUpdater = presenter
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
}

// MARK: - Scrollable

extension ListViewController: Scrollable {
    
    func scrollToTop() {
        guard let tableView = tableView else { return }
        let y = max(topInset, -tableView.safeAreaInsets.top - 52)
        tableView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
}
