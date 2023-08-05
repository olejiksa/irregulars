//
//  IconDetailRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct IconDetailRow: View {
    
    let icon: SystemIcon
    let iconAccessibilityText: LocalizedStringKey
    let text: LocalizedStringKey
    
    var body: some View {
        HStack {
            icon.imageSwiftUI?
                .foregroundColor(AccentColor.current.colorSwiftUI)
                .accessibilityLabel(iconAccessibilityText)
                .font(.title)
                .frame(width: 56)
                .padding(.vertical, 5)
            Text(text)
                .foregroundColor(.secondary)
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

struct IconDetailRow_Previews: PreviewProvider {
    
    static var previews: some View {
        IconDetailRow(
            icon: .sunrise,
            iconAccessibilityText: "sunrise",
            text: "sunrise_question"
        )
    }
}
