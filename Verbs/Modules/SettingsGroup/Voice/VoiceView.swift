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
    
    @State var selectedItem: Voice?
    @State private var isShowingPopover = false
    
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
                    
                } label: {
                    SystemIcon.play.imageSwiftUI
                }
            }
        }
    }
}
