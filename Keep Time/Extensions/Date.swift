//
//  Date.swift
//  Keep Time
//
//  Created by Justin Bane on 11/6/21.
//

import Foundation
import SwiftDate

extension Date {
    
    static var yesterday: Date { return Date().dateAt(.yesterday) }
    static var tomorrow:  Date { return Date().dateAt(.tomorrow) }
    static var startOfToday:  Date { return Date().dateAt(.startOfDay) }
    static var currentMonth:  Date { return Date().dateAt(.startOfMonth) }
    static var lastMonth:  Date { return (Date() - 1.months) }
    

//    Methods
    func isSameDay(firstDay: Date, secondDay: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: firstDay, to: secondDay)
        if diff.day == 0 {
            return true
        }
        return false
    }
    
    func isSameMonth(firstDay: Date, secondDay: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.month], from: firstDay, to: secondDay)
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
