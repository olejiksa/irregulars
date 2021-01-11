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
    let center = UNUserNotificationCenter.current()
    
    init(verbsService: VerbsService) {
        self.verbsService = verbsService
    }
    
    func checkAvailability(availabilityBlock: @escaping BoolBlock) {
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized, .notDetermined:
                availabilityBlock(true)
                
                UserDefaults.shared.bool(for: .notifications) ?
                    self?.schedule() :
                    self?.clean()
            default:
                availabilityBlock(false)
            }
        }
    }
    
    func authorize() {
        DispatchQueue.main.async {
            self.center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                guard granted, error == nil else { return }
                UserDefaults.shared.set(true, for: .notifications)
                self.schedule()
            }
        }
    }
    
    func deauthorize() {
        DispatchQueue.main.async {
            UserDefaults.shared.set(false, for: .notifications)
        }
    }
    
    func schedule() {
        center.removeAllPendingNotificationRequests()
        
        let currentDate = Date()
        
        for i in 0...64 {
            guard let verb = verbsService.randomItem,
                  let missed = (0...2).randomElement(),
                  let date = currentDate.adding(days: i) else { continue }
            
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
            var dateInfo = Calendar.autoupdatingCurrent.dateComponents(components, from: date)
            dateInfo.hour = 9
            dateInfo.minute = 0
            dateInfo.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
            let request = UNNotificationRequest(identifier: verb.infinitive.value,
                                                content: content,
                                                trigger: trigger)
            
            center.add(request) { error in
                guard let error = error else { return }
                print(error)
            }
        }
        
        center.getPendingNotificationRequests(completionHandler: { notifications in
            print("num of pending notifications \(notifications.count)")
        })
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

        return Calendar.current.date(byAdding: dateComponents, to: self)
    }
}
