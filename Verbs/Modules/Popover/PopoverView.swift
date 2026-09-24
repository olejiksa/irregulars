//
//  PopoverView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/14/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    
    @Environment(\.dependencies) private var dependencies
    
    @State private var sliderValue = 0.0
    
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
                dependencies.preferences.playbackSpeed = Int(sliderValue.rounded())
            }
        }
        .frame(minWidth: 250)
        .padding()
        .onAppear { sliderValue = Double(dependencies.preferences.playbackSpeed) }
    }
}

struct PopoverView_Previews: PreviewProvider {
    
    static var previews: some View {
        PopoverView()
    }
}
