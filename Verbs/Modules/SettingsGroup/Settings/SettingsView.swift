//
//  SettingsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        List {
            Section("deactivation".localized) {
                Text("downgrade_to".localized)
            }
            Section("general".localized) {
                Text("language".localized)
                Text("accent_color".localized)
                Text("voice".localized)
                Text("notifications".localized)
            }
            Section("links".localized) {
                Text("rate_and_review".localized)
                Text("rate_and_review".localized)
                Text("rate_and_review".localized)
                Text("terms_of_service".localized)
                Text("contacts_us".localized)
            }
            Section("about".localized) {
                Text("developer".localized)
            }
        }
    }
}
