//
//  Time.swift
//  Keep Time
//
//  Created by Justin Bane on 11/3/21.
//

import Foundation
import CoreData

class TimeHelper: ObservableObject {
    
    let fetchRequest: NSFetchRequest<Log>
    let context = PersistenceController.shared.container.viewContext
    
    init() {
        self.fetchRequest = Log.fetchRequest()
    }
    
    func convertTime(seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getTime(seconds: Int) -> String {
        let timeValues = convertTime(seconds: seconds)
        var timeString = ""
        if timeValues.hours > 0 {
            timeString = timeString + "\(timeValues.hours) \(timeValues.hours > 1 ? "hours" : "hour") "
        }
        if timeValues.minutes > 0 {
            timeString = timeString + "\(timeValues.minutes) minutes"
        }
        return timeString
    }
}
