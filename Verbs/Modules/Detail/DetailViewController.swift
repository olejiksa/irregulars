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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController.map { navigationController($0, willShow: self, animated: animated) }
    }
    
    func getPaid() {
        tableView?.reloadData()
    }
    
    func updateFavoriteButton() {
        favoriteButton?.image = !favorites.verbs.contains(verb) ?
            SystemIcon.star.image :
            SystemIcon.starFill.image
    }
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = presenter.title
        navigationItem.largeTitleDisplayMode = .never
        
//        let moreButton = UIBarButtonItem(image: SystemIcon.ellipsis.image,
//                                         style: .plain,
//                                         target: nil,
//                                         action: nil)
        
        let isFavorite = favorites.verbs.contains(verb)
        let image = isFavorite ? SystemIcon.starFill.image : SystemIcon.star.image
        favoriteButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didFavoriteTap))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupTableView() {
        let tableViewStyle: UITableView.Style = splitViewController?.isCollapsed == true ? .grouped : .insetGrouped
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.register(DetailCell.self, TranslationCell.self, ExampleCell.self)
        
        self.tableView = tableView
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    @objc func didFavoriteTap() {
        updateFavoriteButton()

        if !favorites.verbs.contains(verb) {
            guard !favorites.shouldPaywallBeShown else {
                presenter.router?.goToPaywall()
                return
            }
            
            favorites.add(verb)
        } else {
            favorites.remove(verb)
        }
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
