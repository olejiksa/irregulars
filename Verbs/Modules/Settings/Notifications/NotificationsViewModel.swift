//
//  NotificationsViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/5/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class NotificationsViewModel {
    
    private let calendarService = CalendarService()
    private let notificationService = NotificationService(verbsService: .init(), calendarService: .init())
    
    var areNotificationsAvailable = false
    
    var areNotificationsEnabled: Bool {
        didSet {
            UserDefaults.shared.set(areNotificationsEnabled, for: .notifications)
            
            if areNotificationsEnabled {
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    
                    self.areNotificationsAvailable = await self.notificationService.authorize()
                }
            } else {
                notificationService.deauthorize()
            }
        }
    }
    
    var startDate: Date {
        didSet {
            guard let minutes = calendarService.minutes(from: startDate) else { return }
            UserDefaults.shared.set(minutes, for: .since)
            notificationService.schedule()
        }
    }
    
    var endDate: Date {
        didSet {
            guard let minutes = calendarService.minutes(from: endDate) else { return }
            UserDefaults.shared.set(minutes, for: .to)
            notificationService.schedule()
        }
    }
    
    var frequency: Int {
        didSet {
            UserDefaults.shared.set(frequency, for: .frequency)
            notificationService.schedule()
        }
    }
    
    let frequencyRange = 1...6
    
    init() {
        areNotificationsEnabled = UserDefaults.shared.bool(for: .notifications)
        frequency = UserDefaults.shared.integer(for: .frequency)
        
        let since = UserDefaults.shared.integer(for: .since)
        let to = UserDefaults.shared.integer(for: .to)
        
        startDate = calendarService.date(from: since) ?? .now
        endDate = calendarService.date(from: to) ?? .now
        
        updateNotificationsAvailability()
    }
    
    func updateNotificationsAvailability() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            self.areNotificationsAvailable = await self.notificationService.isAvailable
        }
    }
}
