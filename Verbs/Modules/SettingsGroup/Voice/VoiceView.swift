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
    @State private var isShowingPopover = false
    @State private var isPlaying = false
    
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
        .environment(\.defaultMinListRowHeight, 44)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingPopover = true
                } label: {
                    SystemIcon.ellipsis.imageSwiftUI
                }
                .popover(isPresented: $isShowingPopover) {
                    PopoverView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.play {
                        isPlaying = true
                    } stopHandler: {
                        isPlaying = false
                    }
                } label: {
                    isPlaying ? SystemIcon.stop.imageSwiftUI : SystemIcon.play.imageSwiftUI
                }
            }
        }
    }
}
