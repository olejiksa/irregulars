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
        ZStack {
            Color.blue.ignoresSafeArea()
            
            TabView(selection: $viewModel.selection) {
                ForEach(viewModel.items) { item in
                    OnboardingItemView(item: item)
                        .overlay(alignment: .bottom) {
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
                            .padding()
                            .background(.white,
                                        in: RoundedRectangle(cornerRadius: 10,
                                                             style: .continuous))
                            .offset(y: 50)
                            .transition(.scale.combined(with: .opacity))
                        }
                        .tag(item.id)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onChange(of: viewModel.selection) { value in
                print("selected tab = \(value)")
            }
        }
        .preferredColorScheme(.light)
        .animation(.easeOut(duration: 0.2), value: viewModel.selection)
        .transition(.slide)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
    }
}
