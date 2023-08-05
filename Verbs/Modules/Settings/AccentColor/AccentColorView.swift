//
//  AccentColorView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/11/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct AccentColorView: View {
    
    @StateObject var settingsViewModel: SettingsViewModel
    
    private let appIconService = AppIconService()
    private let rateService = RateService()
    
    @State private var selectedItem: AccentColor? = .current
    
    init(settingsViewModel: SettingsViewModel) {
        AnalyticsService().send(event: .accentColorOpened)
        _settingsViewModel = StateObject(wrappedValue: settingsViewModel)
    }

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(AccentColor.allCases, id: \.self) { item in
                        AccentColorSelectionRow(item: item, selectedItem: $selectedItem) {
                            AccentColor.current = $0
                            settingsViewModel.accentColor = $0
                            rateService.requestReviewIfAppropriate(minimumReviewWorthyActionCount: 10)
                        }
                    }
                }
                
                Section {
                    Button(String.localized(.matchAppIconWithAccentColor)) {
                        appIconService.setIcon(for: AccentColor.current)
                    }
                }
            }
            .navigationTitle("accent_color")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .environment(\.defaultMinListRowHeight, 44)
        }
    }
}

struct AccentColorView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            AccentColorView(settingsViewModel: .init())
        }
    }
}
