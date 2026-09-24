//
//  DeeplinkService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import SwiftUI

final class DeeplinkService {
    
    private let verbsService = VerbsService()
    
    func handle(_ host: String, in splitViewController: UISplitViewController) {
        guard let verb = verbsService.items.first(where: { host == $0.infinitive.value }) else { return }
        
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 0
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            clearTabBarNavigationStack(svc: splitViewController,
                                       nvc: navigationController,
                                       endpoint: .detail)
            handle(host: host,
                   verb: verb,
                   navigationController: navigationController,
                   splitViewController: splitViewController)
        case .regular:
            let navigationController = splitViewController.viewControllers.last as? UINavigationController
            handle(host: host,
                   verb: verb,
                   navigationController: navigationController,
                   splitViewController: splitViewController)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    
    func search(text: String, in splitViewController: UISplitViewController) {
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 0
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            clearTabBarNavigationStack(svc: splitViewController,
                                       nvc: navigationController,
                                       endpoint: .search)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let listViewController = navigationController?.topViewController as? ListViewController
                listViewController?.search(text: text)
            }
        case .regular:
            splitViewController.sidebarViewController?.restore(.all)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let listViewController = splitViewController.supplementaryViewController as? ListViewController
                listViewController?.search(text: text)
            }
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    
    func favorites(in splitViewController: UISplitViewController) {
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 1
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            clearTabBarNavigationStack(svc: splitViewController,
                                       nvc: navigationController,
                                       endpoint: .favorites)
        case .regular:
            splitViewController.sidebarViewController?.restore(.favorites)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    
    func tests(in splitViewController: UISplitViewController) {
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 2
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            clearTabBarNavigationStack(svc: splitViewController,
                                       nvc: navigationController,
                                       endpoint: .tests)
        case .regular:
            splitViewController.sidebarViewController?.restore(.tests)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    
    func statistics(in splitViewController: UISplitViewController) {
        switch splitViewController.traitCollection.horizontalSizeClass {
        case .compact:
            let tabBarController = splitViewController.compactViewController
            tabBarController?.selectedIndex = 2
            let navigationController = tabBarController?.selectedViewController as? UINavigationController
            clearTabBarNavigationStack(svc: splitViewController,
                                       nvc: navigationController,
                                       endpoint: .statistics)
        case .regular:
            splitViewController.sidebarViewController?.restore(.tests)
            let vc = UIHostingController(rootView: StatisticsView())
            splitViewController.secondaryViewController?.push(vc, in: splitViewController)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Private

private extension DeeplinkService {
    
    func checkIfAlreadyOpened(by title: String, in navigationController: UINavigationController?) -> Bool {
        navigationController?.topViewController?.navigationItem.title == title
    }
    
    func handle(host: String,
                verb: Verb,
                navigationController: UINavigationController?,
                splitViewController: UISplitViewController?) {
        guard !checkIfAlreadyOpened(by: host, in: navigationController) else { return }
        splitViewController?.dismiss(animated: true)
        let vc = DetailViewController(verb: verb, isOpenedByDeeplink: true)
        navigationController?.push(vc, in: splitViewController)
    }
    
    func clearTabBarNavigationStack(svc: UISplitViewController,
                                    nvc: UINavigationController?,
                                    endpoint: Endpoint) {
        guard let viewControllers = svc.compactViewController?.viewControllers else { return }
        
        switch endpoint {
        case .detail:
            guard !(nvc?.topViewController is DetailViewController) else { return }
        case .favorites:
            let vc = nvc?.topViewController as? ListViewController
            guard vc == nil || vc?.favoritesOnly == false else { return }
        case .search:
            let vc = nvc?.topViewController as? ListViewController
            guard vc == nil || vc?.favoritesOnly == true else { return }
        case .statistics:
            guard !(nvc?.topViewController is UIHostingController<StatisticsView>) else { return }
        case .tests:
            guard !(nvc?.topViewController is TestsViewController) else { return }
        }
        
        for case let navigationController as UINavigationController in viewControllers {
            navigationController.isNavigationBarHidden = true
            navigationController.popToRootViewController(animated: true)
            navigationController.isNavigationBarHidden = false
        }
        
        if endpoint == .statistics {
            let vc = UIHostingController(rootView: StatisticsView())
            nvc?.push(vc, in: svc)
        }
    }
}
