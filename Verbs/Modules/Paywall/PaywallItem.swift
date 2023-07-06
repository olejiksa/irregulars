//
//  PaywallItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 7/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PaywallItem: View {
    
    let icon: SystemIcon
    let text: String
    
    var body: some View {
        HStack(spacing: 20) {
            icon.imageSwiftUI?
                .foregroundColor(.accentColor)
                .font(.title)
                .frame(width: 48, height: 48)
            Text(text.localized)
        }
        .listRowSeparator(.hidden)
    }
}
