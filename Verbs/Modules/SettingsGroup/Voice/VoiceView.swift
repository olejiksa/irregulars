//
//  VoiceView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct VoiceView: View {
    
    private let viewModel = VoiceViewModel()
    @State private var selectedItem: Voice? = .current
    
    var body: some View {
        List {
            ForEach(Gender.allCases, id: \.self) { gender in
                SwiftUI.Section(gender.description) {
                    ForEach(viewModel.items(for: gender)) { item in
                        VoiceSelectionRow(item: item, selectedItem: $selectedItem)
                    }
                }
            }
            
            SwiftUI.Section {
                Text(String.localized(.voiceHint))
                    .foregroundColor(.secondary)
            }
        }
    }
}
