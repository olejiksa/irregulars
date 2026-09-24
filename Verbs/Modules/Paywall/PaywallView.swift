//
//  PaywallView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 7/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PaywallView: View {
    
    @State private var viewModel: PaywallViewModel
    
    init(purchaseService: PurchaseService) {
        _viewModel = State(wrappedValue: PaywallViewModel(purchaseService: purchaseService))
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                PaywallItem(
                    icon: .creditcard,
                    text: "one_time_payment"
                )
                PaywallItem(
                    icon: .key,
                    text: "unlock_all_verbs_in_tests"
                )
#if !targetEnvironment(macCatalyst)
                PaywallItem(
                    icon: .paintpalette,
                    text: "personalize"
                )
#endif
            }
            .listStyle(.plain)
            // The list runs under the buttons and the system fades its edge, which the
            // screen used to do for itself with a gradient mask.
            .safeAreaInset(edge: .bottom) { actions }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .sensoryFeedback(.error, trigger: viewModel.errorFeedback)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .close) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Private

private extension PaywallView {
    
    @ViewBuilder
    var actions: some View {
        VStack {
            if FeatureToggle.isPaid {
                Text("thank_you")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .padding()
            } else {
                if viewModel.canMakePayments {
                    ForEach(viewModel.purchaseService.products) { product in
                        Button {
                            viewModel.buy(product: product) {
                                dismiss()
                            }
                        } label: {
                            Text("\("buy_for".localized) \(product.displayPrice)")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .opacity(viewModel.isBuyingPurchaseNotInProgress ? 1 : 0)
                                .padding()
                        }
                        .buttonStyle(.glassProminent)
                        .overlay(Group {
                            ProgressView()
                                .opacity(viewModel.isBuyingPurchaseNotInProgress ? 0 : 1)
                        })
                    }
                }
                
                Button {
                    viewModel.restore { dismiss() }
                } label: {
                    Text("restore_purchases")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .opacity(viewModel.isRestoringPurchaseNotInProgress ? 1 : 0)
                        .padding()
                }
                .buttonStyle(.glass)
                .overlay(Group {
                    ProgressView()
                        .opacity(viewModel.isRestoringPurchaseNotInProgress ? 0 : 1)
                })
            }
        }
        .padding()
    }
}

struct PaywallView_Previews: PreviewProvider {
    
    static var previews: some View {
        PaywallView(purchaseService: AppDependencies.shared.purchaseService)
    }
}
