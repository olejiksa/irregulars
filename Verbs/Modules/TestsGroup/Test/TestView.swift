//
//  TestView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = TestViewController
    
    private let test: Test
    
    init(test: Test) {
        self.test = test
    }
    
    func makeUIViewController(context: Context) -> TestViewController {
        let vc = TestAssembly(test: test).viewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: TestViewController, context: Context) {}
}

