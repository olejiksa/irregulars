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
    
    private enum Constants {
        static let buttonHeight: CGFloat = 54
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    PaywallItem(
                        icon: .key,
                        text: "unlock_all_verbs_in_tests"
                    )
                    PaywallItem(
                        icon: .speaker,
                        text: "listen_to_pronunciation"
                    )
                    PaywallItem(
                        icon: .transcription,
                        text: "view_a_transcription"
                    )
                    PaywallItem(
                        icon: .listStar,
                        text: "store_unlimited_items_in_favorites"
                    )
#if !targetEnvironment(macCatalyst)
                    PaywallItem(
                        icon: .paintpalette,
                        text: "personalize"
                    )
#endif
                    PaywallItem(
                        icon: .creditcard,
                        text: "one_time_payment"
                    )
                }
                .listStyle(.plain)
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0.75),
                    .init(color: .clear, location: 1)
                ]), startPoint: .top, endPoint: .bottom))
                
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
                                .buttonStyle(.borderedProminent)
                                .overlay(Group {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
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
                        .buttonStyle(.bordered)
                        .overlay(Group {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                .opacity(viewModel.isRestoringPurchaseNotInProgress ? 0 : 1)
                        })
                    }
                }
                .navigationTitle(viewModel.title)
                .navigationBarTitleDisplayMode(.inline)
                .sensoryFeedback(.error, trigger: viewModel.errorFeedback)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            SystemIcon.close.imageSwiftUI?
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                    }
                }
            }
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    
    static var previews: some View {
        PaywallView(purchaseService: AppDependencies.shared.purchaseService)
    }
}
