//
//  SettingsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    private let viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("general") {
                    Link("language", destination: URL(string: UIApplication.openSettingsURLString)!)
                    NavigationLink("accent_color") {
                        AccentColorView()
                    }
                    NavigationLink("voice") {
                        VoiceView()
                    }
//                    NavigationLink("notifications") {
//                        NotificationsView()
//                    }
                }
                Section("links") {
                    // Link("rate_and_review", destination: viewModel.rateURL!)
                    // Text("share_app")
                    Link("privacy_policy", destination: viewModel.privacyPolicyURL!)
                    Link("terms", destination: viewModel.termsURL!)
                    // Link("contact_us", destination: viewModel.rateURL!)
                }
                Section("about") {
                    RightDetailRowView(title: "developer".localized, subtitle: "oleg_samoylov".localized)
                    RightDetailRowView(title: "edition".localized, subtitle: viewModel.edition)
                    RightDetailRowView(title: "version".localized, subtitle: viewModel.version)
                    NavigationLink("acknowledgements") {
                        AcknowledgementsView()
                    }
                }
            }
            .navigationTitle("settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView()
    }
}
