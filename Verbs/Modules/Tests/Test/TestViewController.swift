//
//  TestViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController {
    
    private let presenter: TestPresenter
    private var tableView: UITableView?
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    init(presenter: TestPresenter, title: String) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.title = title
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupKeyboardService()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.checkAvailability()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func reloadData() {
        let isExpanded = splitViewController?.isCollapsed == false
        
        let transition = CATransition()
        transition.type = .push
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.fillMode = .forwards
        transition.duration = 0.5
        transition.subtype = isExpanded ? .fromRight : .fromTop
        
        tableView?.layer.add(transition, forKey: kCATransition)
        tableView?.reloadData()
        UIAccessibility.post(notification: .screenChanged, argument: tableView)
    }
    
    /// Refreshes the rows in place, without the transition that announces a new question.
    func refreshRows() {
        tableView?.reloadData()
    }
    
    func endEditing() {
        view.endEditing(true)
    }
}

// MARK: - Private

private extension TestViewController {
    
    func setupNavigationBar() {
        navigationItem.title = title
        navigationItem.largeTitleDisplayMode = .never
        
        let shouldMoreButtonBeShown = [Test.listening, Test.speaking].contains(presenter.test)
        let moreButton = shouldMoreButtonBeShown ?
            UIBarButtonItem(icon: .ellipsis, target: self, action: #selector(didMoreButtonTap)) :
            nil
        
        let skipButton = UIBarButtonItem(icon: .skip, target: self, action: #selector(didSkipButtonTap))
        skipButton.accessibilityLabel = "skip".localized
        
        navigationItem.rightBarButtonItems = [skipButton, moreButton].compactMap { $0 }
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
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
        
        tableView.register(PlainDetailCell.self,
                           InputCell.self,
                           AnswerCell.self,
                           RecordCell.self,
                           ActionCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    @objc func didMoreButtonTap(_ sender: UIBarButtonItem) {
        presentPlaybackSpeedPopover(from: sender)
    }
    
    @objc func didSkipButtonTap() {
        presenter.reloadData()
    }
}

// MARK: - Restorable

extension TestViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
        setupKeyboardService()
    }
}

// MARK: - UINavigationControllerDelegate

extension TestViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        
        if viewController is EmptyViewController {
            NotificationCenter.default.post(name: .test, object: nil, userInfo: [:])
        }
    }
}
