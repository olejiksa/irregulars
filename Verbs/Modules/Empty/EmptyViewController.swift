//
//  EmptyViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class EmptyViewController: UIViewController {
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "EmptyVerbs".localized
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController.map { navigationController($0, willShow: self, animated: animated) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe()
        setupDelegate()
        setupNoDataLabel()
        setupView()
    }
}

// MARK: - Private

private extension EmptyViewController {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSidebarItemChange),
                                               name: Notification.Name.sidebar,
                                               object: nil)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    func setupNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
        ])
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func didSidebarItemChange(_ notification: Notification) {
        let areVerbs = notification.userInfo?[Notification.Name.sidebar] as? Bool ?? false
        noDataLabel.text = areVerbs ? "EmptyVerbs".localized : "EmptyTests".localized
    }
}

// MARK: - UINavigationControllerDelegate

extension EmptyViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        NotificationCenter.default.post(name: .infinitive, object: nil, userInfo: [Notification.Name.infinitive: ""])
        NotificationCenter.default.post(name: .test, object: nil, userInfo: nil)
    }
}
