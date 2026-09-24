//
//  EmptyStateView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    
    @State private var text = String(localized: "empty_verbs")
    
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: geometry.size.width * 2 / 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onReceive(NotificationCenter.default.publisher(for: .sidebar)) { notification in
            let areVerbs = notification.userInfo?[Notification.Name.sidebar] as? Bool ?? false
            text = areVerbs ? "empty_verbs".localized : "empty_tests".localized
        }
    }
}

#Preview {
    EmptyStateView()
}
