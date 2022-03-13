//
//  Formatter.swift
//  Keep Time
//
//  Created by Justin Bane on 10/24/21.
//

import Foundation

extension Formatter {
    
    func formatDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func formatTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
