//
//  NotificationsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    
    @State var settingsViewModel: SettingsViewModel
    
    @State private var viewModel = NotificationsViewModel()
    
    var body: some View {
        List {
            Section {
                Text("setup_notifications")
                    .foregroundColor(.secondary)
                if viewModel.areNotificationsAvailable {
                    Toggle("notifications", isOn: $viewModel.areNotificationsEnabled)
                        .tint(AccentColor.current.colorSwiftUI)
                        .onChange(of: viewModel.areNotificationsEnabled) { _, newValue in
                            settingsViewModel.notificationsAvailability = newValue ? .enabled : .disabled
                        }
                } else {
                    Link(destination: URL(string: UIApplication.openNotificationSettingsURLString)!) {
                        RightDetailRow(title: "notifications", subtitle: "not_allowed".localized)
                    }
                }
            }
            if viewModel.areNotificationsAvailable,
               viewModel.areNotificationsEnabled {
                Section("time") {
                    IconDetailRow(icon: .sunrise, iconAccessibilityText: "sunrise", text: "sunrise_question")
                    DatePicker("since", selection: $viewModel.startDate, displayedComponents: .hourAndMinute)
                    IconDetailRow(icon: .sunset, iconAccessibilityText: "sunset", text: "sunset_question")
                    DatePicker("to", selection: $viewModel.endDate, displayedComponents: .hourAndMinute)
                }
                Section("frequency") {
                    Stepper(value: $viewModel.frequency, in: viewModel.frequencyRange) {
                        HStack {
                            Text("count")
                            Spacer()
                            Text(String(viewModel.frequency))
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification
        )) { _ in
            viewModel.updateNotificationsAvailability()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            NotificationsView(settingsViewModel: .init())
        }
    }
}
