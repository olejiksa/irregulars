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
            Section("sentences") {
                Text("sofia_sokolova")
            }
            Section("beta_testing") {
                Text([.localized(.sofiaSokolova),
                      .localized(.artemShumilov),
                      .localized(.elizabethKeplin),
                      .localized(.vladislavPlotnikov)].joined(separator: ", "))
            }
            Section(String.localized(.translation)) {
                RightDetailRow(title: "paulina_litvinova", subtitle: Language.german.description)
                RightDetailRow(title: "julian_eduardo_couoh_pablo", subtitle: Language.spanish.description)
                RightDetailRow(title: "tatiana_perfilieva", subtitle: Language.korean.description)
                RightDetailRow(title: "anastasia_ovcharenko", subtitle: Language.ukrainian.description)
            }
        }
        .navigationTitle("acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AcknowledgementsView_Preview: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            AcknowledgementsView()
        }
    }
}
