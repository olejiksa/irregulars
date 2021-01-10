//
//  PopoverViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PopoverViewController: UIViewController {
    
    private let presenter: PopoverPresenter
    private let width: CGFloat
    private let isCollapsed: Bool
    private var tableView: UITableView?
    private var contentSizeObserver: NSKeyValueObservation?
    
    init(presenter: PopoverPresenter,
         width: CGFloat,
         isCollapsed: Bool) {
        self.presenter = presenter
        self.width = width
        self.isCollapsed = isCollapsed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentSizeObserver = tableView?.observe(\.contentSize) { [weak self] tableView, _ in
            guard let self = self else { return }
            
            self.preferredContentSize = CGSize(width: self.width,
                                               height: tableView.contentSize.height - 24)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        contentSizeObserver?.invalidate()
        contentSizeObserver = nil
    }
}

// MARK: - Private

private extension PopoverViewController {
    
    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: isCollapsed ? .grouped : .insetGrouped)
        
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
        
        tableView.isScrollEnabled = false
        
        tableView.register(SliderCell.self)
        
        self.tableView = tableView
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension PopoverViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
