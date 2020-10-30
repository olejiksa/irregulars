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
    
    @IBOutlet private weak var tableView: UITableView!
    
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
    }
}

// MARK: - Private

private extension TestsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Tests".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseTap))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupTableView() {
        tableView.dataSource = presenter.dataSource
        tableView.delegate = presenter
        
        tableView.register(SubtitleCell.self)
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
}
