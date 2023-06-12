//
//  PhrasalsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/12/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PhrasalsView: View {
    
    private let pharasalsService = PhrasalsService()
    
    var body: some View {
        List(pharasalsService.items, id: \.self) {
            Text($0)
        }
        .listStyle(.plain)
    }
}
