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
//            MARK: Time entry and utilization views
            TimeEntryView(timeUtils: timeUtils, dataUtils: dataUtils, day: day.today)
            
//            Progress view for utilization and total
            UtilizationTotalView(dataUtils: dataUtils)
            
            List {
                ForEach(dataUtils.logsInReport ?? [], id: \.self) { log in
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("\(timeUtils.getTime(seconds: Int(log.seconds)))")
                                .font(.title3)
                                .frame(width: 200, alignment: .leading)
                            
                            if #available(macOS 12.0, *) {
                                Text(log.note ?? "")
                                    .font(.subheadline)
                                    .textSelection(.enabled)
                                    .lineLimit(3)
                            } else {
                                // Fallback on earlier versions
                                Text(log.note ?? "")
                                    .font(.subheadline).textCase(.uppercase)
                                    .lineLimit(3)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            HStack {
                                if log.billable {
                                    Text(Image(systemName: "dollarsign.circle"))
                                        .foregroundColor(.green)
                                } else {
                                    Text(Image(systemName: "brain.head.profile"))
                                        .foregroundColor(.gray)
                                }
                                EditButtonView(timeUtils: timeUtils, dataUtils: dataUtils, log: log, fontSize: .body)
                            }
                            Spacer()
                            Text("\(formatter.formatDateString(date: log.timestamp ?? Date())) \(formatter.formatTimeString(date: log.timestamp ?? Date()))")
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }.onDelete(perform: deleteItem)
            }
        }
    }
    
    func deleteItem(offsets: IndexSet) {
        for index in offsets {
            if let log = dataUtils.logsInReport?[index] {
                dataUtils.context.delete(log)
                dataUtils.logsInReport?.remove(at: index)
                dataUtils.getTodaysTotal()
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
