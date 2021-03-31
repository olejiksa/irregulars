//
//  ListViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    var favoritesOnly: Bool { presenter.favoritesOnly }
    
    // MARK: Keyboard Shortcuts
    
    override var canBecomeFirstResponder: Bool { true }
    
    override var keyCommands: [UIKeyCommand]? {
        let defaultKeyCommands = super.keyCommands ?? []
        let customKeyCommands: [UIKeyCommand] = [.init(title: "search".localized,
                                                       action: #selector(didSearchPress),
                                                       input: "F",
                                                       modifierFlags: .command,
                                                       discoverabilityTitle: "search".localized),
                                                 .init(title: "print".localized,
                                                       action: #selector(didPrintPress),
                                                       input: "P",
                                                       modifierFlags: .command,
                                                       discoverabilityTitle: "print".localized)]
        
        return defaultKeyCommands + customKeyCommands
    }
    
    // MARK: Private Properties

    private let presenter: ListPresenter
    private let searchController = UISearchController(searchResultsController: nil)
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    private var tableView: UITableView?
    private var state: ListState = .data
    private var topInset: CGFloat = 0
    private var listMenu: ListMenu?
    
    private var moreButton: UIBarButtonItem?
    private var editButton: UIBarButtonItem?
    private var doneButton: UIBarButtonItem?
    
    private let noDataLabel = UILabel.noDataLabel
    
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
        setupNoDataLabel()
        setupView()
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
        DispatchQueue.main.async {
            self.reloadData()
            self.setupSearchController()
        }
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
    
    func setState(_ state: ListState) {
        switch state {
        case .data:
            tableView?.isScrollEnabled = true
            noDataLabel.isHidden = true
        case .empty(let text), .searchNotFound(let text), .searchStarted(let text):
            tableView?.isScrollEnabled = false
            noDataLabel.isHidden = false
            
            UIView.transition(with: noDataLabel,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { self.noDataLabel.text = text },
                              completion: nil)
        }
        
        self.state = state
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupNavigationBar() {
        switch (favoritesOnly, splitViewController?.isCollapsed) {
        case (true, _):
            navigationItem.title = "favorites".localized
        case (false, true):
            navigationItem.title = "verbs".localized
        case (false, _):
            navigationItem.title = "all".localized
        }
        
        moreButton = .init(icon: .ellipsis)
        navigationItem.rightBarButtonItem = moreButton
        
        if favoritesOnly {
            editButton = .init(barButtonSystemItem: .edit,
                               target: self,
                               action: #selector(didEditTap))
            doneButton = .init(barButtonSystemItem: .done,
                               target: self,
                               action: #selector(didEditTap))
            
            navigationItem.leftBarButtonItem = editButton
            navigationItem.rightBarButtonItem = moreButton
            
            editButton?.accessibilityIdentifier = AccessibilityIdentifier.editButton.rawValue
            doneButton?.accessibilityIdentifier = AccessibilityIdentifier.doneButton.rawValue
        }
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
        tableView.dragDelegate = presenter
        
        tableView.register(ListCell.self, SubtitleCell.self)
        tableView.tableFooterView = UIView()
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
        ])
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupSearchController() {
        searchController.delegate = presenter
        searchController.searchResultsUpdater = presenter
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    func setupMenu() {
        listMenu = .init(barButtonItem: moreButton,
                         hasTranslation: presenter.hasTranslation,
                         favoritesOnly: favoritesOnly,
                         printInfoBlock: presenter.print,
                         updateDerivativesBlock: favoritesOnly ? nil : presenter.updateDerivatives,
                         updateRegularsBlock: favoritesOnly ? nil : presenter.updateRegulars)
        listMenu?.build()
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    @objc func didEditTap() {
        guard let tableView = tableView else { return }
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            presenter.isEditing = false
            navigationItem.leftBarButtonItem = editButton
        } else {
            tableView.setEditing(true, animated: true)
            presenter.isEditing = true
            navigationItem.leftBarButtonItem = doneButton
        }
    }
    
    // MARK: Keyboard Shortcuts
    
    @objc func didPrintPress() {
        presenter.print()
    }
    
    @objc func didSearchPress() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
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
