//
//  PopoverView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    
    @State private var sliderValue: Double = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("speaking_rate".localized.localizedUppercase)
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                SystemIcon.tortoise.imageSwiftUI?
                    .accessibilityLabel("slower".localized)
                    .foregroundColor(.secondary)
                    .font(.title3)
                Slider(value: $sliderValue, in: 1...5)
                SystemIcon.hare.imageSwiftUI?
                    .accessibilityLabel("faster".localized)
                    .foregroundColor(.secondary)
                    .font(.title3)
            }
        }
        .frame(minWidth: 250)
        .padding()
    }
}

struct PopoverView_Previews: PreviewProvider {
    
    static var previews: some View {
        PopoverView()
    }
}
