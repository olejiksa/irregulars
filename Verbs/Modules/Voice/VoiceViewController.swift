//
//  VoiceViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class VoiceViewController: UIViewController {
    
    private let presenter: VoicePresenter
    private var tableView: UITableView?
    private var playButton: UIBarButtonItem?
    private var stopButton: UIBarButtonItem?
    private var moreButton: UIBarButtonItem?
    
    init(presenter: VoicePresenter) {
        self.presenter = presenter
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
        setupView()
        scrollToRow()
    }
}

// MARK: - Restorable

extension VoiceViewController: Restorable {
    
    func restore() {
        tableView?.removeFromSuperview()
        tableView = nil
        setupTableView()
    }
}

// MARK: - SettingsChildViewControllerProtocol

extension VoiceViewController: SettingsChildViewControllerProtocol {}

// MARK: - Private

private extension VoiceViewController {
    
    func setupNavigationBar() {
        navigationItem.title = .localized(.voice)
        navigationItem.largeTitleDisplayMode = .never
        
        self.moreButton = UIBarButtonItem(image: SystemIcon.ellipsis.image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didMoreButtonTap))
        self.playButton = UIBarButtonItem(image: image(for: .play),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didPlayTap))
        self.stopButton = UIBarButtonItem(image: image(for: .stop),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didPlayTap))
        navigationItem.rightBarButtonItems = [self.playButton, self.moreButton].compactMap { $0 }
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
        
        tableView.register(PlainDetailCell.self, VoiceCell.self)
        
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func scrollToRow() {
        guard let indexPath = presenter.dataSource.selectedIndexPath else { return }
        tableView?.layoutIfNeeded()
        tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    @objc func didPlayTap() {
        presenter.play { [weak self] in
            self?.navigationItem.rightBarButtonItems = [self?.stopButton, self?.moreButton].compactMap { $0 }
        } stopHandler: { [weak self] in
            self?.navigationItem.rightBarButtonItems = [self?.playButton, self?.moreButton].compactMap { $0 }
        }
    }
    
    func image(for playbackIcon: SystemIcon) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        return UIImage(systemName: playbackIcon.rawValue, withConfiguration: configuration)
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
