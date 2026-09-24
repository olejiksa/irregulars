//
//  SidebarViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class SidebarViewController: UIHostingController<SidebarView> {
    
    private let viewModel: SidebarViewModel
    
    init(viewModel: SidebarViewModel) {
        self.viewModel = viewModel
        
        super.init(rootView: SidebarView(viewModel: viewModel))
        
        viewModel.onSelect = { [weak self] destination in self?.open(destination) }
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Bundle.main.productName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Selects the row and opens it, the way a tap would.
    func restore(_ destination: SidebarDestination) {
        viewModel.restore(destination)
    }
}

// MARK: - Private

private extension SidebarViewController {
    
    func open(_ destination: SidebarDestination) {
        guard let splitViewController = splitViewController else { return }
        
        switch destination {
        case .all, .favorites:
            let viewController = ListAssembly(splitViewController: splitViewController,
                                              favoritesOnly: destination == .favorites).viewController()
            splitViewController.setViewController(viewController.navigationController, for: .supplementary)
            
            NotificationCenter.default.post(name: .sidebar,
                                            object: nil,
                                            userInfo: [Notification.Name.sidebar: true])
            
            let navigationController = splitViewController.secondaryViewController
            guard navigationController?.topViewController is TestViewController else { return }
            
            navigationController?.popToRootViewController(animated: true)
        case .tests:
            let viewController = TestsAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(viewController.navigationController, for: .supplementary)
            
            NotificationCenter.default.post(name: .sidebar,
                                            object: nil,
                                            userInfo: [Notification.Name.sidebar: false])
        case .settings:
            let viewController = UIHostingController(rootView: SettingsView().navigationBarHidden(true))
            splitViewController.setViewController(viewController, for: .secondary)
        }
    }
}
