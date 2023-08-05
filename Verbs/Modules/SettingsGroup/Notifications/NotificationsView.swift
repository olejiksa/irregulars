//
//  NotificationsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct NotificationsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> NotificationsViewController {
        NotificationsAssembly().viewController()
    }
    
    func updateUIViewController(_ uiViewController: NotificationsViewController, context: Context) {}
}
