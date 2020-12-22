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
    private var moreButton: UIBarButtonItem?
    private var topInset: CGFloat = 0
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topInset = -(tableView?.safeAreaInsets.top ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .test,
                                        object: nil,
                                        userInfo: [:])
    }
    
    func reloadData() {
        buildMenu(for: moreButton)
        tableView?.reloadData()
    }
}

// MARK: - Scrollable

extension TestsViewController: Scrollable {
    
    func scrollToTop() {
        guard let tableView = tableView else { return }
        let y = max(topInset, -tableView.safeAreaInsets.top - 52)
        tableView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
}

// MARK: - Private

private extension TestsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "tests".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        
        moreButton = .init(image: SystemIcon.ellipsis.image,
                           style: .plain,
                           target: nil,
                           action: nil)
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
        
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.register(TestCell.self)
        
        tableView.tableFooterView = UIView()
        
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
    
    func buildMenu(for barButtonItem: UIBarButtonItem?) {
        let isPaid = FeatureToggle.isPaid
        let favoritesOnly = UserDefaults.shared.bool(for: .favoritesOnly)
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        
        let allMenu = isPaid && !favoritesOnly ?
            [UIMenu(options: .displayInline, children: [
                UIAction(title: "regular_verbs".localized,
                         state: shouldRegularVerbsBeShown ? .on : .off,
                         handler: handleRegularsMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: "derivatives".localized,
                         state: shouldDerivativesBeShown ? .on : .off,
                         handler: handleDerivativesMenu)
            ])] : []
        
        barButtonItem?.menu = .init(children: [
            UIMenu(options: .displayInline, children: [
                UIAction(title: "demo".localized,
                         image: SystemIcon.twentyFive.image,
                         attributes: !isPaid ? [] : .hidden,
                         state: !isPaid ? .on : .off,
                         handler: handleMenu),
                UIAction(title: "all".localized,
                         image: SystemIcon.listBullet.image,
                         state: isPaid && !favoritesOnly ? .on : .off,
                         handler: handleMenu),
                UIAction(title: "favorites".localized,
                         image: SystemIcon.star.image,
                         state: isPaid && favoritesOnly ? .on : .off,
                         handler: handleMenu)
            ])
        ] + allMenu)
    }
    
    func handleMenu(action: UIAction) {
        let isPaid = FeatureToggle.isPaid
        
        if isPaid {
            let favoritesOnly = UserDefaults.shared.bool(for: .favoritesOnly)
            let state = action.state == .on
            let newState = favoritesOnly == state
            UserDefaults.shared.set(newState, for: .favoritesOnly)
        } else if action.state == .off {
            presenter.router?.goToPaywall()
        } else {
            return
        }
        
        buildMenu(for: moreButton)
    }
    
    func handleRegularsMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            presenter.router?.goToPaywall()
            return
        }
        
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        UserDefaults.shared.set(!shouldRegularVerbsBeShown, for: .regularVerbsTests)
        buildMenu(for: moreButton)
    }
    
    func handleDerivativesMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            presenter.router?.goToPaywall()
            return
        }
        
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        UserDefaults.shared.set(!shouldDerivativesBeShown, for: .derivativesTests)
        buildMenu(for: moreButton)
    }
}
