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

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = ListViewController()
        let nvc = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }
}
