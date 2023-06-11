//
//  AccentColorView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/11/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct AccentColorView: View {
    
    private let appIconService = AppIconService()
    
    @State private var selectedItem: AccentColor? = .current

    var body: some View {
        VStack {
            List {
                ForEach(AccentColor.allCases) { item in
                    AccentColorViewSelectionRow(item: item, selectedItem: $selectedItem)
                }
            }
            
            Button(String.localized(.matchAppIconWithAccentColor)) {
                appIconService.setIcon(for: AccentColor.current)
            }
        }
    }
}

struct AccentColorViewSelectionRow: View {
    
    private let rateService = RateService()
    
    let item: AccentColor
    @Binding var selectedItem: AccentColor?
    @State private var isShowingPaywall = false
    
    var body: some View {
        HStack {
            Text(item.rawValue.localized)
            Spacer()
            if item == selectedItem {
                Image(systemName: "checkmark")
                    .foregroundColor(AccentColor.current.colorSwiftUI)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard FeatureToggle.isPaid else {
                isShowingPaywall = true
                return
            }
            
            selectedItem = item
            AccentColor.current = selectedItem ?? .blue
            rateService.requestReviewIfAppropriate(minimumReviewWorthyActionCount: 10)
        }
        .sheet(isPresented: $isShowingPaywall) {
            Paywall()
        }
    }
}
