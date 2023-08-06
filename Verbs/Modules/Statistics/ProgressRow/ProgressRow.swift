//
//  ProgressRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/6/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct ProgressRow: View {
    
    let value: Int
    let maximum: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProgressView(value: Float(value) / Float(maximum))
            Text("\(value) \(String(format: "of".localized, maximum))")
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 7)
        .padding(.bottom, 1)
    }
}

struct ProgressRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressRow(value: 5, maximum: 8)
    }
}
