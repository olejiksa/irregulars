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
        maximumSupplementaryColumnWidth = 2_000
        preferredSupplementaryColumnWidthFraction = 0.5
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
    
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        guard let compactVc = svc.compactViewController,
              let sidebarVc = svc.primaryViewController
        else { return }
        
        switch (compactVc.selectedIndex) {
        case 0:
            let nvc = compactVc.viewControllers?[0] as? UINavigationController
            let vc = nvc?.topViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sidebarVc.restore(at: IndexPath(row: 1, section: 0))
                svc.secondaryViewController?.popToRootViewController(animated: false)
                if let detailVc = vc as? DetailViewController {
                    let newVc = DetailViewController(detailViewController: detailVc)
                    svc.secondaryViewController?.pushViewController(newVc, animated: true)
                }
            }
        case 1:
            let nvc = compactVc.viewControllers?[1] as? UINavigationController
            let vc = nvc?.topViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sidebarVc.restore(at: IndexPath(row: 2, section: 0))
                svc.secondaryViewController?.popToRootViewController(animated: false)
                if let detailVc = vc as? DetailViewController {
                    let newVc = DetailViewController(detailViewController: detailVc)
                    svc.secondaryViewController?.pushViewController(newVc, animated: true)
                }
            }
        case 2:
            let nvc = compactVc.viewControllers?[2] as? UINavigationController
            let vc = nvc?.topViewController
            svc.secondaryViewController?.popToRootViewController(animated: false)
            if let detailVc = vc as? SettingsViewController {
                let newVc = SettingsViewController(settingsViewController: detailVc)
                svc.secondaryViewController?.pushViewController(newVc, animated: true)
            }
        default:
            break
        }
    }
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        guard let supplementaryVc = svc.supplementaryViewController?.topViewController,
              let secondaryVc = svc.secondaryViewController?.topViewController
        else {
            return
        }
        
        switch (supplementaryVc, secondaryVc) {
        case (is ListViewController, is EmptyViewController):
            showDetail(svc, supplementaryVc, nil, 0)
        case (is ListViewController, is DetailViewController):
            showDetail(svc, supplementaryVc, secondaryVc, 0)
        case (is FavoritesViewController, is EmptyViewController):
            showDetail(svc, supplementaryVc, nil, 1)
        case (is FavoritesViewController, is DetailViewController):
            showDetail(svc, supplementaryVc, secondaryVc, 1)
        case (_, is SettingsViewController):
            showDetail(svc, supplementaryVc, secondaryVc, 2)
        default:
            break
        }
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
    
    func showDetail(_ svc: UISplitViewController,
                    _ supplementaryVc: UIViewController?,
                    _ secondaryVc: UIViewController?,
                    _ index: Int) {
        svc.compactViewController?.selectedIndex = index

        for i in 0...2 {
            let nvc = svc.compactViewController?.viewControllers?[i] as? UINavigationController
            guard let vc = (nvc?.viewControllers.first {
                $0 is ListViewController ||
                $0 is FavoritesViewController ||
                $0 is SettingsViewController
            }) else { continue }
            nvc?.popToViewController(vc, animated: false)
            nvc?.isNavigationBarHidden = true
            nvc?.isNavigationBarHidden = false
        }
        
        let nvc = svc.compactViewController?.viewControllers?[index] as? UINavigationController
        
        switch secondaryVc {
        case let detailVc as DetailViewController:
            let newVc = DetailViewController(detailViewController: detailVc)
            nvc?.pushViewController(newVc, animated: false)
        case let settingsVc as SettingsViewController:
            let newVc = SettingsViewController(settingsViewController: settingsVc)
            nvc?.pushViewController(newVc, animated: false)
        default:
            break
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
