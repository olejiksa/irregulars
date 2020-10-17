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
    private let isOpenedByDeeplink: Bool
    
    @IBOutlet private weak var tableView: UITableView!
    
    init(presenter: DetailPresenter,
         isOpenedByDeeplink: Bool = false) {
        self.presenter = presenter
        self.isOpenedByDeeplink = isOpenedByDeeplink
        
        super.init(nibName: nil, bundle: nil)
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
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = presenter.title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        tableView.dataSource = presenter
        tableView.delegate = presenter
        
        tableView.register(DetailCell.self, TranslationCell.self)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
}

// MARK: - UINavigationControllerDelegate

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated || isOpenedByDeeplink else { return }
        let title = viewController.navigationItem.title ?? ""
        NotificationCenter.default.post(name: Notification.Name.infinitive,
                                        object: nil,
                                        userInfo: ["infinitive": title])
    }
}
