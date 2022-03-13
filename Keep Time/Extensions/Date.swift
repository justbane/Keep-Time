//
//  Date.swift
//  Keep Time
//
//  Created by Justin Bane on 11/6/21.
//

import Foundation

extension Date {
    
    var dayBefore: Date {
        return getLocalCalendar().date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return getLocalCalendar().date(byAdding: .day, value: 1, to: noon)!
    }
    var today: Date {
        return getLocalCalendar().date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var endOfToday: Date {
        return getLocalCalendar().date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    var noon: Date {
        return getLocalCalendar().date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var now: Date {
        let now = getLocalCalendar().dateComponents(in: .current, from: self)
        let nowDate = DateComponents(year: now.year, month: now.month, day: now.day, hour: now.hour, minute: now.minute, second: now.second)
        return getLocalCalendar().date(from: nowDate)!
    }
    var month: Int {
        return getLocalCalendar().component(.month,  from: self)
    }
    var lastmonth: Date {
        return getLocalCalendar().date(byAdding: .month, value: -1, to: self)!
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    func getLocalCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        if let timezone = TimeZone(identifier: TimeZone.current.abbreviation()!) {
            calendar.timeZone = timezone
        }
        return calendar
        
    }
    
    func isToday(day: Date) -> Bool {
        let diff = isSameDay(firstDay: today, secondDay: day)
        if diff {
            return true
        }
        return false
    }
    
    func isSameDay(firstDay: Date, secondDay: Date) -> Bool {
        let diff = getLocalCalendar().dateComponents([.day], from: firstDay, to: secondDay)
        if diff.day == 0 {
            return true
        }
        return false
    }
    
    func isSameMonth(firstDay: Date, secondDay: Date) -> Bool {
        let diff = getLocalCalendar().dateComponents([.month], from: firstDay, to: secondDay)
        if diff.day == 0 {
            return true
        }
        return false
    }
    
    func getDaysInMonth() -> [Date] {
//        Need to work this out
        return [Date()]
    }
    
}
