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
    
    init() {
        UIPageControl.appearance().overrideUserInterfaceStyle = .light
    }
    
    var body: some View {
        NavigationView {
            let view = VStack {
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
                        .frame(width: 200)
                        .padding()
                }
                .contentShape(Rectangle())
                .font(.system(size: 20,
                              weight: .bold,
                              design: .rounded))
                .background(.white,
                            in: RoundedRectangle(cornerRadius: 10,
                                                 style: .continuous))
                .transition(.scale.combined(with: .opacity))
            }
            .preferredColorScheme(.light)
            .animation(.easeOut(duration: 0.2), value: viewModel.selection)
            .transition(.slide)
            .preferredColorScheme(.light)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        SystemIcon.close.imageSwiftUI
                    }
                }
            }
            
            if #available(macCatalyst 13.2, *) {
                view.background(Color.accentColor)
            } else {
                view.background(AccentColor.current.colorSwiftUI)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
    }
}
