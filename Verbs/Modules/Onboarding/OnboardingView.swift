//
//  OnboardingView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TabView(selection: $viewModel.selection) {
                ForEach(viewModel.items) { item in
                    OnboardingItemView(item: item)
                        .tag(item.id)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Button {
                if viewModel.isLast {
                    dismiss()
                } else {
                    viewModel.selection += 1
                }
            } label: {
                Text(viewModel.isLast ? "Начать" : "Продолжить")
            }
            .font(.system(size: 20,
                          weight: .bold,
                          design: .rounded))
            .frame(width: 200)
            .padding()
            .background(.white,
                        in: RoundedRectangle(cornerRadius: 10,
                                             style: .continuous))
            .transition(.scale.combined(with: .opacity))
        }
        .preferredColorScheme(.light)
        .animation(.easeOut(duration: 0.2), value: viewModel.selection)
        .transition(.slide)
        .preferredColorScheme(.light)
        .background(.blue)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
    }
}
