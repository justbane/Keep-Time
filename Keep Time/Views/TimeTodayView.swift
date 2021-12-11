//
//  ListView.swift
//  Keep Time
//
//  Created by Justin Bane on 10/23/21.
//

import SwiftUI
import SwiftDate

struct TimeTodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Log.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.timestamp, ascending: false)],
        predicate: NSPredicate(format: "timestamp >= %@", Date.startOfToday as CVarArg),
        animation: .default)
    private var logs: FetchedResults<Log>
    
    private var formatter = Formatter()
    @StateObject var timeUtils = TimeHelper()
    @StateObject var dataUtils = DataManager()
    
    var body: some View {
        VStack {
            TimeEntryView(timeUtils: timeUtils, dataUtils: dataUtils, day: Date())
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
            List {
                ForEach(logs) { log in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(timeUtils.getTime(seconds: Int(log.seconds)))").font(.title)
                            HStack {
                                Text(formatter.formatTimeString(date: log.timestamp ?? Date()))
                                Spacer()
                                Text(log.note ?? "")
                                    .font(.subheadline).textCase(.uppercase)
                            }.padding(.bottom)
                            Divider()
                        }
                    }
                    .padding(5)
                   
                }.onDelete(perform: deleteItems)
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
