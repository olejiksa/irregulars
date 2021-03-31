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
    private var keyboardService: KeyboardService?
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
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
        setupKeyboardService()
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
        
        moreButton = .init(icon: .ellipsis,
                           style: .plain,
                           target: self,
                           action: #selector(didMoreButtonTap))
        playButton = .init(icon: .play,
                           style: .done,
                           target: self,
                           action: #selector(didPlayTap))
        playButton?.accessibilityTraits = [.button, .playsSound]
        stopButton = .init(icon: .stop,
                           style: .done,
                           target: self,
                           action: #selector(didPlayTap))
        navigationItem.rightBarButtonItems = [playButton, moreButton].compactMap { $0 }
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
        
        tableView.register(PlainDetailCell.self, VoiceCell.self)
        
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.tableView = tableView
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupKeyboardService() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
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
        playbackIcon.image
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
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
}
