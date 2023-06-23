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
    
    init() {
        AnalyticsService().send(event: .accentColorOpened)
    }

    var body: some View {
        VStack {
            List {
                SwiftUI.Section {
                    ForEach(AccentColor.allCases, id: \.self) { item in
                        AccentColorSelectionRow(item: item, selectedItem: $selectedItem)
                    }
                }
                
                SwiftUI.Section {
                    Button(String.localized(.matchAppIconWithAccentColor)) {
                        appIconService.setIcon(for: AccentColor.current)
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 44)
        }
    }
}
