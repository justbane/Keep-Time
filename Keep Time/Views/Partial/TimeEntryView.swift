//
//  TimeEntry.swift
//  Keep Time
//
//  Created by Justin Bane on 11/3/21.
//

import SwiftUI

struct TimeEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var timeUtils: TimeHelper
    @ObservedObject var dataUtils: DataManager
    @State var isShowing: Bool = false
    @State var selectedTime: Int = 0
    @State var note: String = ""
    
    let day: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Add Time: ")
                Text(timeUtils.getTime(seconds: selectedTime))
                Spacer()
                Text(dataUtils.todaysTotal)
            }
            .onAppear(perform: {
                dataUtils.setTheDay(day: day)
            })
            .font(.title3)
            
            HStack {
                Button {
                    if selectedTime > 0 {
                        selectedTime -= 900
                    }
                } label: {
                    Image(systemName: "minus.square")
                }.buttonStyle(.borderless)
                
                Button {
                    selectedTime += 900
                } label: {
                    Image(systemName: "plus.square")
                }.buttonStyle(.borderless)

                TextField("Note", text: $note)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    addTime()
                } label: {
                    Text("Bank It").font(.body)
                }
            }
        }
        .font(.title2)
        .padding()
        .background(Color(.sRGB,white: 0.11,opacity: 10000))
            
    }
    
    private func addTime() {
        if (note != "" && selectedTime > 0) {
            withAnimation {
                let newItem = Log(context: viewContext)
                newItem.seconds = Int32(selectedTime)
                newItem.note = note
                
                newItem.timestamp = day.dateByAdding(2, .hour).date
                do {
                    try viewContext.save()
                    dataUtils.getTodaysTotal()
                    dataUtils.getLogsForDate(day: day)
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

struct TimeEntry_Previews: PreviewProvider {
    static var previews: some View {
        let timeUtils = TimeHelper()
        let dataUtils = DataManager()
        TimeEntryView(timeUtils: timeUtils, dataUtils: dataUtils, day: Date())
    }
}
