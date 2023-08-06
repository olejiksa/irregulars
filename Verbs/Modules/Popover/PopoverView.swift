//
//  PopoverView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    
    @State private var sliderValue = Double(UserDefaults.shared.integer(for: .playbackSpeed))
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("speaking_rate".localized.localizedUppercase)
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Slider(value: $sliderValue, in: 0...4, step: 1) {
                
            } minimumValueLabel: {
                SystemIcon.tortoise.imageSwiftUI?
                    .accessibilityLabel("slower".localized)
                    .foregroundColor(.secondary)
                    .font(.title3)
            } maximumValueLabel: {
                SystemIcon.hare.imageSwiftUI?
                    .accessibilityLabel("faster".localized)
                    .foregroundColor(.secondary)
                    .font(.title3)
            } onEditingChanged: { _ in
                let roundedValue = Int(sliderValue.rounded())
                UserDefaults.shared.set(roundedValue, for: .playbackSpeed)
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
