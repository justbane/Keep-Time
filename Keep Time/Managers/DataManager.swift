//
//  DataUtils.swift
//  Keep Time
//
//  Created by Justin Bane on 11/7/21.
//
import Foundation
import CoreData

class DataManager: ObservableObject {
    @Published var todaysTotal = "No hours today"
    @Published var daysInReport: [Date] = [Date()]
    @Published var logsInReport: [Log]?
    @Published var dayRanges: (from: Date, to: Date) = (.lastMonth, Date())
    
    let fetchRequest: NSFetchRequest<Log>
    let context = PersistenceController.shared.container.viewContext
    
    var day: Date = Date()
    
    init() {
        self.fetchRequest = Log.fetchRequest()
        getTodaysTotal()
        getDaysByDate(from: dayRanges.from, to: dayRanges.to)
    }
    
//    MARK: Set the day
    func setTheDay(day: Date) {
        self.day = day
        getTodaysTotal()
    }
    
//    MARK: Get the fetch request
    func getLogsRequest(before: Date, after: Date) -> NSFetchRequest<Log> {
        let beforePreicate = NSPredicate(format: "timestamp >=  %@", before as CVarArg)
        let afterPredicate = NSPredicate(format: "timestamp <=  %@", after as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                beforePreicate,
                afterPredicate
            ]
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Log.timestamp, ascending: false)
        ]
        
        return fetchRequest
    }
    
//    MARK: Total for the day
    func getTodaysTotal() {
        let logs = try? context.fetch(getLogsRequest(before: day.dateAt(.startOfDay), after: day.dateAt(.endOfDay)))
        var totalSeconds = 0
        for log in logs! {
            totalSeconds += Int(log.seconds)
        }
        self.todaysTotal = TimeHelper().getTime(seconds: totalSeconds)
    }
    
//    MARK: Get the days for the date range
    func getDaysByDate(from: Date, to: Date) {
        let logs = try? context.fetch(getLogsRequest(before: from, after: to))
        var days: [Date] = []
        for day in logs! {
            let currentDay = day.timestamp!.dateAtStartOf(.day)
            if !days.contains(currentDay) {
                days.append(currentDay)
            }
        }
        daysInReport = days
        dayRanges = (from, to)
    }
    
//    MARK: Logs for the day
    func getLogsForDate(day: Date) {
        let logs = try? context.fetch(getLogsRequest(before: day.dateAt(.startOfDay), after: day.dateAt(.endOfDay)))
        if let logArray = logs {
            logsInReport = logArray
        } else {
            fatalError("Found no logs for that day")
        }
    }
    
}
