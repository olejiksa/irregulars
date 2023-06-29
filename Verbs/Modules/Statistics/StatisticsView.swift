//
//  StatisticsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct StatisticsView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = StatisticsViewController
    
    func makeUIViewController(context: Context) -> StatisticsViewController {
        let vc = StatisticsAssembly().viewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: StatisticsViewController, context: Context) {}
}

