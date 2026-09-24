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
    private let preferences: Preferences
    private let notificationService: NotificationService
    
    var areNotificationsAvailable = false
    
    var areNotificationsEnabled: Bool {
        didSet {
            preferences.areNotificationsEnabled = areNotificationsEnabled
            
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
            preferences.notificationsSince = minutes
            notificationService.schedule()
        }
    }
    
    var endDate: Date {
        didSet {
            guard let minutes = calendarService.minutes(from: endDate) else { return }
            preferences.notificationsUntil = minutes
            notificationService.schedule()
        }
    }
    
    var frequency: Int {
        didSet {
            preferences.notificationsPerDay = frequency
            notificationService.schedule()
        }
    }
    
    let frequencyRange = 1...6
    
    init(dependencies: AppDependencies) {
        let preferences = dependencies.preferences
        self.preferences = preferences
        notificationService = dependencies.makeNotificationService()
        
        areNotificationsEnabled = preferences.areNotificationsEnabled
        frequency = preferences.notificationsPerDay
        
        let since = preferences.notificationsSince
        let to = preferences.notificationsUntil
        
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
