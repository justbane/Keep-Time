//
//  EditDay.swift
//  Keep Time
//
//  Created by Justin Bane on 11/14/21.
//

import SwiftUI

struct TimeHistoryListView: View {
    @ObservedObject var dataUtils: DataManager
    @ObservedObject var timeUtils: TimeHelper
    
    var formatter = Formatter()
    var day: Date
    
    var body: some View {
        VStack {
            TimeEntryView(timeUtils: timeUtils, dataUtils: dataUtils, day: day)
            List {
                ForEach(dataUtils.logsInReport ?? [], id: \.self) { log in
                    HStack {
                        Text("\(timeUtils.getTime(seconds: Int(log.seconds)))")
                            .font(.title3)
                            .frame(width: 200, alignment: .leading)
                        Text("\(formatter.formatDateString(date: log.timestamp ?? Date())) \(formatter.formatTimeString(date: log.timestamp ?? Date()))")
                        Spacer()
                        Text(log.note ?? "")
                            .font(.subheadline).textCase(.uppercase)
                    }
                    .padding(.horizontal)
                }.onDelete(perform: deleteItem)
            }
        }
    }
    
    func deleteItem(offsets: IndexSet) {
        for index in offsets {
            if let log = dataUtils.logsInReport?[index] {
                dataUtils.context.delete(log)
                dataUtils.logsInReport?.remove(at: index)
            }
        }
        do {
            try dataUtils.context.save()
        } catch {
            fatalError("Well that didn't work")
        }
    }
}

struct EditDay_Previews: PreviewProvider {
    static var previews: some View {
        TimeHistoryListView(dataUtils: DataManager(), timeUtils: TimeHelper(), day: Date())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
