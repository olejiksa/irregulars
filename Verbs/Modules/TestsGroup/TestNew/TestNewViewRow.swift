//
//  TestNewViewRow.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestNewViewRow: View {
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
    }
}

struct TestNewViewRow_Previews: PreviewProvider {
    
    static var previews: some View {
        TestNewViewRow("Juice")
    }
}
