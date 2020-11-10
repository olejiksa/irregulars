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
        label.text = "EmptyDetail".localized
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
        
        setupDelegate()
        setupNoDataLabel()
        setupView()
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
}

// MARK: - UINavigationControllerDelegate

extension EmptyViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        NotificationCenter.default.post(name: .infinitive,
                                        object: nil,
                                        userInfo: [Notification.Name.infinitive: ""])
    }
}
