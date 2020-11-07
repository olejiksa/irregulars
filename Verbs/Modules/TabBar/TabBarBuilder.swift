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
    
    func build(in splitViewController: SplitViewController?) -> TabBarController? {
        guard let splitViewController = splitViewController else { return nil }
        
        let firstVc = ListAssembly().viewController(inside: splitViewController).navigationController
        firstVc?.tabBarItem = .init(title: "Verbs".localized, image: SystemIcon.bookFill.image, tag: 0)
        let secondVc = ListAssembly().viewController(inside: splitViewController).navigationController
        secondVc?.tabBarItem = .init(title: "Favorites".localized, image: SystemIcon.starFill.image, tag: 1)
        let thirdVc = SettingsAssembly().viewController().navigationController
        thirdVc?.tabBarItem = .init(title: "Settings".localized, image: SystemIcon.gear.image, tag: 2)
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [firstVc, secondVc, thirdVc].compactMap { $0 }
        
        return tabBarController
    }
}
