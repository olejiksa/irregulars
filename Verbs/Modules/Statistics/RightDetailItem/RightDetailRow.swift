//
//  RightDetailRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/9/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct RightDetailRow: View {
    
    let title: LocalizedStringKey
    let subtitle: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(subtitle).foregroundColor(.secondary)
        }
    }
}
