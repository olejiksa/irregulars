//
//  VoiceView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct VoiceView: View {
    
    @StateObject private var viewModel = VoiceViewModel()
    
    var body: some View {
        List {
            ForEach(Gender.allCases, id: \.self) { gender in
                SwiftUI.Section(gender.description) {
                    ForEach(viewModel.items(for: gender)) { item in
                        VoiceSelectionRow(item: item, selectedItem: $viewModel.selectedItem)
                    }
                }
            }
            
            SwiftUI.Section {
                Text(String.localized(.voiceHint))
                    .foregroundColor(.secondary)
            }
        }
        .environment(\.defaultMinListRowHeight, 60)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.play) {
                    viewModel.isPlaying ? SystemIcon.stop.imageSwiftUI : SystemIcon.play.imageSwiftUI
                }
            }
        }
    }
}
