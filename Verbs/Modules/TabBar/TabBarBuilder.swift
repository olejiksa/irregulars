//
//  TabBarBuilder.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TabBarBuilder {
    
    weak var scrollView: UIScrollView?
    
    func build(in svc: SplitViewController?) -> TabBarController? {
        guard let svc = svc else { return nil }
        
        let listVc = ListAssembly(splitViewController: svc).viewController().navigationController
        let favoritesVc = FavoritesAssembly(splitViewController: svc).viewController().navigationController
        let settingsVc = SettingsAssembly().viewController().navigationController
        
        return compound(items: [(listVc, "Verbs".localized, .bookFill),
                                (favoritesVc, "Favorites".localized, .starFill),
                                (settingsVc, "Settings".localized, .gear)])
    }
}

// MARK: - Private

private extension TabBarBuilder {
    
    func compound(items: [(controller: UIViewController?,
                           title: String,
                           icon: SystemIcon)]) -> TabBarController {
        items.enumerated().forEach {
            $1.controller?.tabBarItem = .init(title: $1.title, image: $1.icon.image, tag: $0)
        }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = items.map { $0.controller }.compactMap { $0 }
        return tabBarController
    }
}
