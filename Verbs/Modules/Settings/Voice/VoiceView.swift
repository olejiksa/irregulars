//
//  VoiceView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct VoiceView: View {
    
    @State var settingsViewModel: SettingsViewModel
    
    @State private var viewModel = VoiceViewModel()
    
    var body: some View {
        List {
            ForEach(Gender.allCases, id: \.self) { gender in
                Section(gender.description) {
                    ForEach(viewModel.items(for: gender)) { item in
                        VoiceSelectionRow(item: item, selectedItem: $viewModel.selectedItem) {
                            Voice.current = $0
                            settingsViewModel.voice = $0
                        }
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.isShowingSpeakingRate = true
                } label: {
                    SystemIcon.ellipsis.imageSwiftUI
                }
                Button(action: viewModel.play) {
                    viewModel.isPlaying ? SystemIcon.stop.imageSwiftUI : SystemIcon.play.imageSwiftUI
                }
                .popover(isPresented: $viewModel.isShowingSpeakingRate) {
                    PopoverView()
                        .presentationCompactAdaptation(
                            horizontal: .popover,
                            vertical: .sheet
                        )
                }
            }
        }
    }
}

struct VoiceView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            VoiceView(settingsViewModel: .init())
        }
    }
}
