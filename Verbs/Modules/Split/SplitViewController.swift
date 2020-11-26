//
//  SplitViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private let splitStateManager = SplitStateManager()
    
    init() {
        super.init(style: .tripleColumn)
        delegate = splitStateManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredBehavior(for: view.bounds.size.width)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        updatePreferredBehavior(for: size.width)
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - Internal

extension UISplitViewController {
    
    var compactViewController: UITabBarController? {
        viewController(for: .compact) as? UITabBarController
    }
    
    var sidebarViewController: SidebarViewController? {
        (viewController(for: .primary) as? UINavigationController)?.topViewController as? SidebarViewController
    }
    
    var secondaryViewController: UINavigationController? {
        viewController(for: .secondary) as? UINavigationController
    }
    
    var supplementaryViewController: UIViewController? {
        (viewController(for: .supplementary) as? UINavigationController)?.topViewController
    }
}

// MARK: - Private

private extension SplitViewController {
    
    func updatePreferredBehavior(for width: CGFloat) {
        if width >= 1024 {
            preferredDisplayMode = .twoBesideSecondary
            preferredSplitBehavior = .tile
        } else {
            preferredDisplayMode = .oneBesideSecondary
            preferredSplitBehavior = .displace
        }
    }
}
