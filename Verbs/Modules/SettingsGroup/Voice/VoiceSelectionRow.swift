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
                SystemIcon.checkmark.imageSwiftUI?
                    .fontWeight(.semibold)
                    .foregroundColor(AccentColor.current.colorSwiftUI)
            }
        }
        .onTapGesture {
            guard FeatureToggle.isPaid else {
                isShowingPaywall = true
                return
            }
            
            selectedItem = item
            Gender.current = item.gender
            Region.current = item.region
            UserDefaults.shared.set(item.id, for: .voice)
            NotificationCenter.default.post(name: .reload, object: nil)
        }
        .sheet(isPresented: $isShowingPaywall) {
            Paywall()
        }
    }
}
