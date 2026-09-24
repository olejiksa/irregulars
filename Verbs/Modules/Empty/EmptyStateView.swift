//
//  EmptyStateView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    
    /// The sidebar section the reader is in, which decides what the column says.
    let destination: SidebarDestination
    
    var body: some View {
        GeometryReader { geometry in
            Text(verbatim: text)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: geometry.size.width * 2 / 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var text: String {
        destination == .tests ? "empty_tests".localized : "empty_verbs".localized
    }
}

#Preview {
    EmptyStateView(destination: .all)
}
