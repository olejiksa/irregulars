//
//  EmptyViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class EmptyViewController: UIHostingController<EmptyStateView> {
    
    init() {
        super.init(rootView: EmptyStateView())
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        navigationController?.delegate = self
        view.backgroundColor = .systemBackground
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
