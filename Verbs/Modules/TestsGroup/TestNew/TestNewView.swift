//
//  TestNewView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestNewView: View {
    
    @State private var downloadAmount = 0.0
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ProgressView("Вопрос 1 из 10", value: downloadAmount, total: 100)
                .onReceive(timer) { _ in
                    if downloadAmount < 100 {
                        downloadAmount += 10
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            List {
                
                SwiftUI.Section(String.localized(.infinitive)) {
                    TestNewViewRow("outfight")
                }
                SwiftUI.Section(String.localized(.translation)) {
                    TestNewViewRow("спешить, ускорять")
                    TestNewViewRow("встречать, знакомиться")
                    TestNewViewRow("побеждать в бою")
                    TestNewViewRow("догонять")
                }
            }
            .environment(\.defaultMinListRowHeight, 60)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(String.localized(.translation))
        }
    }
}

struct TestNewView_Previews: PreviewProvider {
    
    static var previews: some View {
        TestNewView()
    }
}
