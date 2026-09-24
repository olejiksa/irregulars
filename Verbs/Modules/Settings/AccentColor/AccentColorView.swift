//
//  AccentColorView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/11/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct AccentColorView: View {
    
    @State var settingsViewModel: SettingsViewModel
    
    private let appIconService = AppIconService()
    private let rateService: RateService
    
    @State private var selectedItem: AccentColor? = .current
    
    init(settingsViewModel: SettingsViewModel, dependencies: AppDependencies) {
        _settingsViewModel = State(wrappedValue: settingsViewModel)
        rateService = dependencies.makeRateService()
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
                    Button(String(localized: "match_app_icon_with_accent_color")) {
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
            AccentColorView(settingsViewModel: .init(dependencies: .shared), dependencies: .shared)
        }
    }
}
