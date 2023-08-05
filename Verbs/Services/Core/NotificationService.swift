//
//  NotificationService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit
import UserNotifications

final class NotificationService {
    
    private let verbsService: VerbsService
    private let calendarService: CalendarService
    private let center = UNUserNotificationCenter.current()
    
    init(verbsService: VerbsService,
         calendarService: CalendarService) {
        self.verbsService = verbsService
        self.calendarService = calendarService
    }
    
    var isAvailable: Bool {
        get async {
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized, .notDetermined:
                defer {
                    if UserDefaults.shared.bool(for: .notifications) {
                        schedule()
                    } else {
                        clean()
                    }
                }
                
                return true
            default:
                return false
            }
        }
    }
    
    func authorize() async -> Bool {
        let result = try? await self.center.requestAuthorization(options: [.alert, .sound])
        
        if result == true {
            UserDefaults.shared.set(true, for: .notifications)
            schedule()
            return true
        } else {
            return false
        }
    }
    
    func deauthorize() {
       Task {
            UserDefaults.shared.set(false, for: .notifications)
        }
    }
    
    func schedule() {
        clean()
        
        let currentDate = Date()
        let resolvedNotificationsCount = 64
        
        let frequency = UserDefaults.shared.integer(for: .frequency)
        
        let since = UserDefaults.shared.integer(for: .since)
        guard let sinceDate = calendarService.date(from: since) else { return }
        
        let to = UserDefaults.shared.integer(for: .to)
        guard let toDate = calendarService.date(from: to) else { return }
        
        var i = 0
        
        while i < resolvedNotificationsCount {
            guard let date = currentDate.adding(days: i) else { continue }
            
            let dates = calendarService.schedule(count: frequency, startDate: sinceDate, endDate: toDate)
            
            for frequencyDate in dates {
                guard let verb = verbsService.randomItem,
                      let missed = (0...2).randomElement() else { continue }
                
                let infinitive = verb.infinitive.value
                let simplePast = verb.simplePast?.first?.value ?? "..."
                let pastParticiple = verb.pastParticiple?.first?.value ?? "..."
                
                let body: String
                switch missed {
                case 0:
                    body = "... | \(simplePast) | \(pastParticiple)"
                case 1:
                    body = "\(infinitive) | ... | \(pastParticiple)"
                case 2:
                    body = "\(infinitive) | \(simplePast) | ..."
                default:
                    body = "Not Supported"
                }
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "what_is", arguments: nil)
                content.body = body
                content.sound = UNNotificationSound.default
                
                let components: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute, .second]
                let frequencyInfo = Calendar.autoupdatingCurrent.dateComponents(components, from: frequencyDate)
                var dateInfo = Calendar.autoupdatingCurrent.dateComponents(components, from: date)
                dateInfo.hour = frequencyInfo.hour
                dateInfo.minute = frequencyInfo.minute
                dateInfo.second = frequencyInfo.second
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                let request = UNNotificationRequest(identifier: verb.infinitive.value,
                                                    content: content,
                                                    trigger: trigger)
                
                center.add(request) {
                    guard let error = $0 else { return }
                    print(error)
                }
                
                i += 1
            }
        }
    }
    
    func clean() {
        center.removeAllPendingNotificationRequests()
    }
}

// MARK: - Private

private extension Date {
    
    func adding(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days

        return Calendar.autoupdatingCurrent.date(byAdding: dateComponents, to: self)
    }
}
