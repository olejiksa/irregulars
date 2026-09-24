//
//  AccentColorSelectionRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/12/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct AccentColorSelectionRow: View {
    
    @Environment(\.dependencies) private var dependencies
    
    let item: AccentColor
    @Binding var selectedItem: AccentColor?
    let onTap: (AccentColor) -> Void
    
    @State private var isShowingPaywall = false
    
    var body: some View {
        HStack {
            Circle()
                .strokeBorder(item.colorSwiftUI, lineWidth: 3)
                .background(
                    Circle().foregroundColor(item.colorSwiftUI)
                        .frame(width: 12.5, height: 12.5)
                )
                .frame(width: 25, height: 25)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            Text(item.rawValue.localized)
            Spacer()
            if item == selectedItem {
                SystemIcon.checkmark.imageSwiftUI?
                    .fontWeight(.semibold)
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
            onTap(item)
        }
        .sheet(isPresented: $isShowingPaywall) {
            PaywallView(purchaseService: dependencies.purchaseService)
        }
    }
}
