//
//  SettingsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/29/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            if !viewModel.isPaid {
                Section("activation") {
                    Button("upgrade_to_pro") {
                        viewModel.isShowingPaywall = true
                    }
                }
            }
            Section("general") {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                    RightDetailRow(title: "language", subtitle: viewModel.language)
                }
                NavigationLink {
                    AccentColorView(settingsViewModel: viewModel)
                } label: {
                    RightDetailRow(title: "accent_color", subtitle: viewModel.accentColor.rawValue.localized)
                }
                NavigationLink {
                    VoiceView(settingsViewModel: viewModel)
                } label: {
                    if let voiceName = viewModel.voice?.name {
                        RightDetailRow(title: "voice", subtitle: voiceName)
                    } else {
                        RightDetailRow(title: "voice", subtitle: "default".localized)
                    }
                }
                NavigationLink {
                    NotificationsView(settingsViewModel: viewModel)
                } label: {
                    RightDetailRow(title: "notifications", subtitle: viewModel.notificationsAvailability.rawValue.localized)
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
                    RightDetailRow(title: "developer", subtitle: "oleg_samoylov".localized)
                }
                .disabled(!viewModel.canOpenAllApps)
                Button {
                    viewModel.isShowingPaywall = true
                } label: {
                    RightDetailRow(title: "edition", subtitle: viewModel.edition)
                }
                Button("FAQ") {
                    viewModel.isShowingFAQ = true
                }
                RightDetailRow(title: "version", subtitle: viewModel.version)
            }
        }
        .sheet(isPresented: $viewModel.isShowingPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $viewModel.isShowingFAQ) {
            OnboardingView()
        }
        .navigationTitle("settings")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification
        )) { _ in
            viewModel.updateNotificationsAvailability()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView()
    }
}
