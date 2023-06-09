//
//  AcknowledgementsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/9/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct AcknowledgementsView: View {
    
    var body: some View {
        List {
            SwiftUI.Section(String.localized(.sentences)) {
                Text(String.localized(.sofiaSokolova))
            }
            SwiftUI.Section(String.localized(.betaTesting)) {
                Text([.localized(.sofiaSokolova),
                      .localized(.artemShumilov),
                      .localized(.elizabethKeplin),
                      .localized(.vladislavPlotnikov)].joined(separator: ", "))
            }
            SwiftUI.Section(String.localized(.translation)) {
                HStack {
                    Text(String.localized(.polinaLitvinova))
                    Spacer()
                    Text(Language.german.description).foregroundColor(Color(.secondaryLabel))
                }
                HStack {
                    Text(String.localized(.julianEduardo))
                    Spacer()
                    Text(Language.spanish.description).foregroundColor(Color(.secondaryLabel))
                }
                HStack {
                    Text(String.localized(.tatianaPerfilieva))
                    Spacer()
                    Text(Language.korean.description).foregroundColor(Color(.secondaryLabel))
                }
                HStack {
                    Text(String.localized(.anastasiaOvcharenko))
                    Spacer()
                    Text(Language.ukrainian.description).foregroundColor(Color(.secondaryLabel))
                }
            }
            .navigationBarTitle(String.localized(.acknowledgements), displayMode: .inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
