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
        setupTableView()
        setupSearchController()
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
    
    func deselectWhenCompact() {
        guard splitViewController?.isCollapsed == true,
              let indexPath = tableView?.indexPathForSelectedRow else { return }
        tableView?.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupNavigationBar() {
        if splitViewController?.isCollapsed == true {
            navigationItem.title = "Verbs".localized
        } else {
            navigationItem.title = "All".localized
        }
        
        moreButton = LanguageService().hasTranslation ?
            .init(image: SystemIcon.ellipsis.image,
                  style: .plain,
                  target: nil,
                  action: nil)
            : nil
        buildMenu(for: moreButton)
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
}

// MARK: - Scrollable

extension ListViewController: Scrollable {
    
    func scrollToTop() {
        guard let tableView = tableView else { return }
        let y = min(-196, -tableView.safeAreaInsets.top)
        tableView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
}
