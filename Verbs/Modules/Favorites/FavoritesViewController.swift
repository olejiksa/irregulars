//
//  FavoritesViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {

    private let presenter: FavoritesPresenter
    private let searchController = UISearchController(searchResultsController: nil)
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    private var tableView: UITableView?
    private var state: ListState = .empty
    
    private var moreButton: UIBarButtonItem?
    private var editButton: UIBarButtonItem?
    private var doneButton: UIBarButtonItem?
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "EmptyFavorites".localized
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    init(presenter: FavoritesPresenter) {
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
        setupSearchController()
        setupNoDataLabel()
        setupView()
        setupKeyboardService()
        presenter.selectWhenRegular()
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
        buildMenu(for: moreButton)
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
    
    func setState(_ state: ListState) {
        guard state != self.state else { return }
        
        switch state {
        case .data:
            tableView?.isHidden = false
            noDataLabel.isHidden = true
        case .empty:
            tableView?.isHidden = true
            noDataLabel.isHidden = false
        }
        
        self.state = state
    }
    
    func deselectWhenCompact() {
        guard splitViewController?.isCollapsed == true,
              let indexPath = tableView?.indexPathForSelectedRow else { return }
        tableView?.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private

private extension FavoritesViewController {
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Favorites".localized
        
        moreButton = LanguageService().hasTranslation ?
            .init(image: SystemIcon.ellipsis.image,
                  style: .plain,
                  target: nil,
                  action: nil)
            : nil
        buildMenu(for: moreButton)
        
        editButton = .init(barButtonSystemItem: .edit,
                           target: self,
                           action: #selector(didEditTap))
        doneButton = .init(barButtonSystemItem: .done,
                           target: self,
                           action: #selector(didEditTap))
        
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = moreButton
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
    
    func buildMenu(for barButtonItem: UIBarButtonItem?) {
        let isTranslation = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
        
        barButtonItem?.menu = .init(children: [
            UIAction(title: "Verb forms".localized,
                     state: !isTranslation ? .on : .off,
                     handler: handleMenu),
            UIAction(title: "Translation".localized,
                     state: isTranslation ? .on : .off,
                     handler: handleMenu)
        ])
    }
    
    func handleMenu(action: UIAction) {
        let isPaid = FeatureToggle.isPaid
        
        if isPaid {
            let isTranslation = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
            let state = action.state == .on
            let newState = isTranslation == state
            UserDefaults.shared.set(newState, for: .shouldTranslationBeShown)
            NotificationCenter.default.post(name: .list,
                                            object: nil,
                                            userInfo: [Notification.Name.list: newState])
        } else if action.state == .off {
            presenter.router?.goToPaywall()
        } else {
            return
        }
        
        buildMenu(for: moreButton)
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
}

// MARK: - Scrollable

extension FavoritesViewController: Scrollable {
    
    func scrollToTop() {
        guard let tableView = tableView else { return }
        let y = min(-196, -tableView.safeAreaInsets.top)
        tableView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
}
