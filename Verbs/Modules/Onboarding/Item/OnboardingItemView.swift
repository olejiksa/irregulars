//
//  OnboardingItemView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct OnboardingItemView: View {
    
    let item: OnboardingItem
    
    /// Big enough to carry the page, and still grows with the reader's text size.
    @ScaledMetric(relativeTo: .largeTitle) private var emojiSize: CGFloat = 120
    
    var body: some View {
        VStack(spacing: 16) {
            Text(item.emoji)
                .font(.system(size: emojiSize))
                .accessibilityHidden(true)
            Text(item.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(item.content)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .fontDesign(.rounded)
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    OnboardingItemView(item: OnboardingItem(
        id: 0,
        emoji: "🤝",
        title: "Join the crew",
        content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"))
}
