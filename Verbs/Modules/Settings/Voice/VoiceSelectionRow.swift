//
//  VoiceSelectionRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct VoiceSelectionRow: View {
    
    let item: Voice
    @Binding var selectedItem: Voice?
    let onTap: (Voice) -> Void
    
    @State private var isShowingPaywall = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.body)
                Text(item.region.description)
                    .font(.caption)
            }
            Spacer()
            if item == selectedItem {
                if #available(macCatalyst 13.2, *) {
                    SystemIcon.checkmark.imageSwiftUI?
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                } else {
                    SystemIcon.checkmark.imageSwiftUI?
                        .fontWeight(.semibold)
                        .foregroundColor(AccentColor.current.colorSwiftUI)
                }
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
            PaywallView()
        }
    }
}
