//
//  SplitViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private var viewDidLoadCalled = false
    
    init() {
        super.init(style: .tripleColumn)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredBehavior(for: view.bounds.size.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updatePreferredBehavior(for: size.width)
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - UISplitViewControllerDelegate

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        guard let supplementaryVc = svc.supplementaryViewController?.topViewController,
              let secondaryVc = svc.secondaryViewController?.topViewController
        else {
            return topColumnForCollapsingToProposedTopColumn
        }
        
        switch (supplementaryVc, secondaryVc) {
        case (is ListViewController, is EmptyViewController):
            showDetail(svc, nil, 0)
        case (is ListViewController, is DetailViewController):
            showDetail(svc, secondaryVc, 0)
        case (is FavoritesViewController, is EmptyViewController):
            showDetail(svc, nil, 1)
        case (is FavoritesViewController, is DetailViewController):
            showDetail(svc, secondaryVc, 1)
        case (_, is SettingsViewController):
            svc.compactViewController?.selectedIndex = 2
        default:
            break
        }
        
        return topColumnForCollapsingToProposedTopColumn
    }
    
    func splitViewController( _ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        print("proposedDisplayMode: \(proposedDisplayMode.rawValue)")
        return proposedDisplayMode
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
    
    func showDetail(_ svc: UISplitViewController, _ secondaryVc: UIViewController?, _ index: Int) {
        svc.compactViewController?.selectedIndex = index
        for i in 0...2 {
            let nvc = svc.compactViewController?.viewControllers?[i] as? UINavigationController
            nvc?.popToRootViewController(animated: false)
        }
        if let secondaryVc = secondaryVc {
            let nvc = svc.compactViewController?.viewControllers?[index] as? UINavigationController
            nvc?.pushViewController(secondaryVc, animated: true)
            NotificationCenter.default.post(name: .infinitive,
                                            object: nil,
                                            userInfo: [Notification.Name.infinitive: ""])
        }
    }
}

extension UISplitViewController {
    
    var compactViewController: UITabBarController? {
        viewController(for: .compact) as? UITabBarController
    }
    
    var primaryViewController: SidebarViewController? {
        (viewController(for: .primary) as? UINavigationController)?.topViewController as? SidebarViewController
    }
    
    var secondaryViewController: UINavigationController? {
        viewController(for: .secondary) as? UINavigationController
    }
    
    var supplementaryViewController: UINavigationController? {
        viewController(for: .supplementary) as? UINavigationController
    }
}
