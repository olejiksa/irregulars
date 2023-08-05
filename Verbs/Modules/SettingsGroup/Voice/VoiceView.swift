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
                Section(gender.description) {
                    ForEach(viewModel.items(for: gender)) { item in
                        VoiceSelectionRow(item: item, selectedItem: $viewModel.selectedItem)
                    }
                }
            }
            
            Section {
                Text(String.localized(.voiceHint))
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("voice")
        .navigationBarTitleDisplayMode(.inline)
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

struct VoiceView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            VoiceView()
        }
    }
}
