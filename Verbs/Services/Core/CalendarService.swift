//
//  CalendarService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import Foundation

final class CalendarService {
    
    func schedule(count: Int, startDate: Date, endDate: Date) -> [Date] {
        switch count {
        case ..<1:
            return []
        case 1:
            return [startDate]
        case 2:
            return [startDate, endDate]
        default:
            let remainingCount = count - 1
            
            let maxDate = max(startDate, endDate)
            let minDate = min(startDate, endDate)
            
            let interval = minDate.distance(to: maxDate)
            let segment = Int(interval) / remainingCount
            
            let otherDates = (1..<remainingCount).compactMap {
                Calendar.autoupdatingCurrent.date(byAdding: .second,
                                                  value: segment * $0,
                                                  to: minDate)
            }
            
            return ([startDate] + otherDates + [endDate]).sorted()
        }
    }
    
    func date(from value: Int) -> Date? {
        let hour = value / 60
        let minute = value % 60
        let components = DateComponents(hour: hour, minute: minute)
        return Calendar.autoupdatingCurrent.date(from: components)
    }
    
    func minutes(from date: Date) -> Int? {
        let components = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else { return nil }
        return hour * 60 + minute
    }
}
