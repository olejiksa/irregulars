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
