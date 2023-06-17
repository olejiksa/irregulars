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
    
    var body: some View {
        VStack(spacing: 0) {
            Text(item.emoji)
                .font(.system(size: 150))
            Text(item.title)
                .font(.system(size: 35,
                              weight: .heavy,
                              design: .rounded))
                .padding(.bottom, 12)
            Text(item.content)
                .font(.system(size: 18,
                              weight: .semibold,
                              design: .rounded))
                .padding(.bottom, 12)
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .padding()
    }
}

struct OnboardingItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        let item = OnboardingItem(
            id: 0,
            emoji: "🤝",
            title: "Join the crew",
            content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry")
        OnboardingItemView(item: item)
            .previewLayout(.sizeThatFits)
            .background(.blue)
    }
}
