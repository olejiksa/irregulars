//
//  SplitView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/18/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct SplitView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> SplitViewController {
        let splitViewController = SplitViewController()
        let sidebarViewController = SidebarAssembly().viewController()
        let sidebarNavigationController = UINavigationController(rootViewController: sidebarViewController)
        let supplementaryViewController = ListAssembly(splitViewController: splitViewController,
                                                       favoritesOnly: false).viewController()
        let secondaryViewController = EmptyViewController()
        let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)
        let tabbarViewController = TabBarController(splitViewController: splitViewController)
        splitViewController.primaryBackgroundStyle = .sidebar
        splitViewController.setViewController(sidebarNavigationController, for: .primary)
        splitViewController.setViewController(supplementaryViewController.navigationController, for: .supplementary)
        splitViewController.setViewController(secondaryNavigationController, for: .secondary)
        splitViewController.setViewController(tabbarViewController, for: .compact)
        return splitViewController
    }
    
    func updateUIViewController(_ uiViewController: SplitViewController, context: Context) {}
}
