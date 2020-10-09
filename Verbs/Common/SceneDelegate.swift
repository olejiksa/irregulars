//
//  SceneDelegate.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let deeplinkService = DeeplinkService()
    
    private var splitViewController: UISplitViewController = {
        let svc = SplitViewController()
        let masterVc = ListAssembly().viewController(with: svc)
        let detailVc = EmptyViewController()
        let detailNvc = UINavigationController(rootViewController: detailVc)
        svc.viewControllers = [masterVc.navigationController, detailNvc].compactMap { $0 }
        return svc
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let context = URLContexts.first,
            let host = context.url.host
        else { return }
        
        deeplinkService.handle(host, in: splitViewController)
    }
}
