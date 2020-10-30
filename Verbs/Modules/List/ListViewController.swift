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
    
    @IBOutlet private weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    init(presenter: ListPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardService()
        setupNavigationBar()
        setupNavigationBarButtons()
        setupTableView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard animated else { return }
        NotificationCenter.default.post(name: Notification.Name.infinitive,
                                        object: nil,
                                        userInfo: ["infinitive": ""])
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func getPaid() {
        tableView.reloadData()
        setupSearchController()
    }
    
    func selectRow(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
            
            return
        }
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Verbs".localized
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavigationBarButtons() {
        let tests = UIBarButtonItem(title: "Tests".localized,
                                    style: .plain,
                                    target: presenter,
                                    action: #selector(presenter.goToTests))
        navigationItem.leftBarButtonItem = tests
        
        let settings = UIBarButtonItem(image: SystemIcon.gear.image,
                                       style: .plain,
                                       target: presenter,
                                       action: #selector(presenter.goToSettings))
        navigationItem.rightBarButtonItem = settings
    }
    
    func setupTableView() {
        tableView.dataSource = presenter
        tableView.delegate = presenter
        
        tableView.register(ListCell.self, SubtitleCell.self)
    }
    
    func setupSearchController() {
        guard FeatureToggle.isPaid else { return }
        
        searchController.delegate = presenter
        searchController.searchResultsUpdater = presenter
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
}
