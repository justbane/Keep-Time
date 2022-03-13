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
    @State var selectedType: Int = 1
    
    let day: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Button {
                    if selectedTime > 0 {
                        selectedTime -= 900
                    }
                } label: {
                    Image(systemName: "minus.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.borderless)
                
                Button {
                    selectedTime += 900
                } label: {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.borderless)
                
                Text(timeUtils.getTime(seconds: selectedTime))
                Spacer()
                Text(dataUtils.todaysTotal)
            }.onAppear(perform: {
                dataUtils.setTheDay(day: day)
            }).font(.title3)
                .padding(.bottom, 5)
            
            HStack {
                TextField("Note", text: $note)
                
                Spacer()
                
                Picker("", selection: $selectedType) {
                    Image(systemName: "dollarsign.circle").tag(1)
                    Image(systemName: "brain.head.profile").tag(2)
                }.pickerStyle(.segmented)
                    .frame(width: 100)
                
                Button {
                    addTime()
                } label: {
                    Text("Add Time").font(.body)
                }
            }
            
        }
        .font(.title2)
        .padding()
        
    }
    
    private func addTime() {
        if (note != "" && selectedTime > 0) {
            withAnimation {
                let newItem = Log(context: viewContext)
                newItem.seconds = Int32(selectedTime)
                newItem.note = note
                newItem.billable = (selectedType == TimeTypes.Billable.rawValue) ? true : false
                newItem.timestamp = day
                
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
