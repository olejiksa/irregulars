//
//  Paywall.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/11/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct Paywall: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        return nvc
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
