//
//  SettingsNewView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct SettingsNewView: View {
    
    var body: some View {
        List {
            SwiftUI.Section("deactivation".localized) {
                Text("downgrade_to".localized)
            }
            SwiftUI.Section("general".localized) {
                Text("language".localized)
                Text("accent_color".localized)
                Text("voice".localized)
                Text("notifications".localized)
            }
            SwiftUI.Section("links".localized) {
                Text("rate_and_review".localized)
                Text("rate_and_review".localized)
                Text("rate_and_review".localized)
                Text("terms_of_service".localized)
                Text("contacts_us".localized)
            }
            SwiftUI.Section("about".localized) {
                Text("developer".localized)
            }
        }
    }
}
