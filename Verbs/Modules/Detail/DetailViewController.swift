//
//  DetailViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let presenter: DetailPresenter
    private let verb: Verb
    private let isOpenedByDeeplink: Bool
    private var favoriteButton: UIBarButtonItem?
    private var favorites = Locator.favorites
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: DetailPresenter,
         verb: Verb,
         isOpenedByDeeplink: Bool = false) {
        self.presenter = presenter
        self.verb = verb
        self.isOpenedByDeeplink = isOpenedByDeeplink
        
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
        setupKeyboardService()
        updateFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController.map { navigationController($0, willShow: self, animated: animated) }
    }
    
    func getPaid() {
        tableView?.reloadData()
    }
    
    func updateFavoriteButton() {
        favoriteButton?.image = !Locator.favorites.verbs.contains(verb) ?
            SystemIcon.star.image :
            SystemIcon.starFill.image
    }
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = presenter.title
        navigationItem.largeTitleDisplayMode = .never
        
        let moreButton = UIBarButtonItem(icon: .ellipsis, target: self, action: #selector(didMoreButtonTap))
        let isFavorite = Locator.favorites.verbs.contains(verb)
        let icon = isFavorite ? SystemIcon.starFill : SystemIcon.star
        favoriteButton = UIBarButtonItem(icon: icon, target: self, action: #selector(didFavoriteTap))
        navigationItem.rightBarButtonItems = [favoriteButton, moreButton].compactMap { $0 }
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(DetailCell.self, TranslationCell.self, ExampleCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    @objc func didFavoriteTap() {
        updateFavoriteButton()

        if !Locator.favorites.verbs.contains(verb) {
            guard !Locator.favorites.shouldPaywallBeShown else {
                presenter.router?.goToPaywall()
                return
            }
            
            Locator.favorites.add(verb)
        } else {
            Locator.favorites.remove(verb)
        }
    }
    
    @objc func didMoreButtonTap(_ sender: UIBarButtonItem) {
        let viewController = PopoverAssembly(width: view.frame.width - 40,
                                             isCollapsed: splitViewController?.isCollapsed ?? false).viewController()
        viewController.modalPresentationStyle = .popover
        guard let popoverViewController = viewController.popoverPresentationController else { return }
        popoverViewController.barButtonItem = sender
        popoverViewController.delegate = viewController
        present(viewController, animated: true)
    }
}

// MARK: - Restorable

extension DetailViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - UINavigationControllerDelegate

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated || isOpenedByDeeplink else { return }
        let title = viewController.navigationItem.title ?? ""
        NotificationCenter.default.post(name: .infinitive,
                                        object: nil,
                                        userInfo: [Notification.Name.infinitive: title])
    }
}
