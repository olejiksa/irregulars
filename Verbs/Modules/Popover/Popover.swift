//
//  Popover.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct Popover: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PopoverViewController
    
    func makeUIViewController(context: Context) -> PopoverViewController {
        let vc = PopoverAssembly(width: 0).viewController()
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = vc
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PopoverViewController, context: Context) {}
}
