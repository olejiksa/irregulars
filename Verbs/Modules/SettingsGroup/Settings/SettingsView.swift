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
                    Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                        RightDetailRowView(title: "language".localized, subtitle: viewModel.language)
                    }
                    NavigationLink("accent_color") {
                        AccentColorView()
                    }
                    NavigationLink("voice") {
                        VoiceView()
                    }
                    NavigationLink("notifications") {
                        NotificationsView()
                    }
                }
                Section("links") {
                    Link("privacy_policy", destination: viewModel.privacyPolicyURL!)
                    Link("terms", destination: viewModel.termsURL!)
                    Button("contact_us") {
                        viewModel.openMail()
                    }
                    .disabled(!viewModel.canOpenMail)
                    Button("rate_and_review") {
                        viewModel.rateAndReview()
                    }
                    .disabled(!viewModel.canOpenRateAndReview)
                    ShareLink("share_app", item: viewModel.webURL!)
                }
                Section("about") {
                    Link(destination: viewModel.developerURL!) {
                        RightDetailRowView(title: "developer".localized, subtitle: "oleg_samoylov".localized)
                    }
                    .disabled(!viewModel.canOpenAllApps)
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
