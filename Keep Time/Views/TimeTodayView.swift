//
//  ListView.swift
//  Keep Time
//
//  Created by Justin Bane on 10/23/21.
//

import SwiftUI

struct TimeTodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Log.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.timestamp, ascending: false)],
        predicate: NSPredicate(format: "timestamp >= %@", Date().today as CVarArg),
        animation: .default)
    private var logs: FetchedResults<Log>
    
    private var formatter = Formatter()
    @StateObject var timeUtils = TimeHelper()
    @StateObject var dataUtils = DataManager()
    
    @State var utilization = 0
    @State var selectedlog: Log?
    
    var body: some View {
        VStack {
            TimeEntryView(timeUtils: timeUtils, dataUtils: dataUtils, day: Date().now)
            listView
            Spacer()
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if logs.isEmpty {
            VStack {
                Spacer()
                Text("Are you even working today?").font(.title)
                Text("Add some time!!").font(.headline)
                Spacer()
            }
        } else {
            
            VStack {
//                Progress view for utilization and total
                UtilizationTotalView(dataUtils: dataUtils)
                List {
                    ForEach(logs, id: \.self) { log in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(timeUtils.getTime(seconds: Int(log.seconds)))").font(.title)
                                if #available(macOS 12.0, *) {
                                    Text(log.note ?? "").textSelection(.enabled)
                                } else {
                                    // Fallback on earlier versions
                                    Text(log.note ?? "")
                                }
                            }
                            Spacer()
                            VStack {
                                HStack(alignment: .top) {
                                    if log.billable {
                                        Text(Image(systemName: "dollarsign.circle"))
                                            .foregroundColor(.green)
                                            .font(.title)
                                    } else {
                                        Text(Image(systemName: "brain.head.profile"))
                                            .foregroundColor(.gray)
                                            .font(.title)
                                    }
                                    EditButtonView(timeUtils: timeUtils, dataUtils: dataUtils, log: log, fontSize: .title)
                                }.padding(.bottom, 3)
                                Text(formatter.formatTimeString(date: log.timestamp ?? Date().now))
                                    .font(.subheadline).textCase(.uppercase)
                            }
                            
                        }
                        .padding(5)
                        .cornerRadius(10)
                       
                    }.onDelete(perform: deleteItems)
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewContext.perform {
                offsets.map { logs[$0] }.forEach(viewContext.delete)
                do {
                    try viewContext.save()
                    dataUtils.getTodaysTotal()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTodayView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
