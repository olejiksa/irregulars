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
                RightDetailRowView(title: .localized(.polinaLitvinova), subtitle: Language.german.description)
                RightDetailRowView(title: .localized(.julianEduardo), subtitle: Language.spanish.description)
                RightDetailRowView(title: .localized(.tatianaPerfilieva), subtitle: Language.korean.description)
                RightDetailRowView(title: .localized(.anastasiaOvcharenko), subtitle: Language.ukrainian.description)
            }
        }
    }
}
