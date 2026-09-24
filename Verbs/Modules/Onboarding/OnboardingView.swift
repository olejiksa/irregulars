//
//  OnboardingView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selection) {
                ForEach(viewModel.items) { item in
                    OnboardingItemView(item: item)
                        .tag(item.id)
                }
            }
            .tabViewStyle(.page)
            .animation(.easeOut(duration: 0.2), value: viewModel.selection)
            .safeAreaInset(edge: .bottom) { action }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .close) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Private

private extension OnboardingView {
    
    var action: some View {
        Button {
            if viewModel.isLast {
                dismiss()
            } else {
                viewModel.selection += 1
            }
        } label: {
            Text(viewModel.isLast ? "start" : "continue")
                .font(.headline)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
        }
        .buttonStyle(.glassProminent)
        .controlSize(.large)
        .padding()
    }
}

#Preview {
    OnboardingView()
}
