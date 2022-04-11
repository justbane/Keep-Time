//
//  TimeEditView.swift
//  Keep Time
//
//  Created by Justin Bane on 4/10/22.
//

import SwiftUI

struct TimeEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var timeUtils: TimeHelper
    @ObservedObject var dataUtils: DataManager
    
    @State var selectedTime: Int = 0
    @State var note: String = ""
    @State var selectedType: Int = 1
    @State var showingTags: Bool = false
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    let log: Log
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
//                TODO: Add preference pane for time entry
//                DatePicker("From", selection: $startDate,
//                           in: ...Date(),
//                           displayedComponents: .hourAndMinute
//                )
//                .datePickerStyle(.compact)
//
//                DatePicker("To", selection: $endDate,
//                           in: ...Date().endOfToday,
//                           displayedComponents: .hourAndMinute
//                ).datePickerStyle(.compact)
                
                Button {
                    if selectedTime > 0 {
                        selectedTime -= 900
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.borderless)

                Button {
                    selectedTime += 900
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.borderless)
                
                Spacer()
                
                TextField("Note: ", text: $note)
                
                Spacer()
                
//                TODO: implement tags functionality
//                Button {
//                    showingTags = !showingTags
//                } label: {
//                    Text("Tags")
//                }.popover(isPresented: $showingTags) {
//                    Text("Tags partial here")
//                }
                
                Picker("", selection: $selectedType) {
                    Image(systemName: "dollarsign.circle").tag(1)
                    Image(systemName: "brain.head.profile").tag(2)
                }
                .pickerStyle(.segmented)
                .frame(width: 100)
                .help("Billable or Overhead")
                
                Button {
                    editEntry(log: log)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save").font(.body)
                }
            }
            .font(.title3)
            .padding(.bottom, 5)
            
            HStack {
//                Add preference pane for time entry
//                Text(timeUtils.getTime(seconds: Int(startDate.distance(to: endDate))))
                Text(timeUtils.getTime(seconds: selectedTime))
                Spacer()
            }
            
        }
        .frame(width: 400, height: 100)
        .font(.title2)
        .padding()
        .onAppear(){
            selectedTime = Int(log.seconds)
            note = log.note ?? ""
            selectedType = log.billable ? 1 : 2
        }

    }
    
    private func editEntry(log: Log) {
        log.seconds = Int32(selectedTime)
        log.note = note
        log.billable = (selectedType == TimeTypes.Billable.rawValue) ? true : false
        do {
            try viewContext.save()
            dataUtils.getTodaysTotal()
            dataUtils.getLogsForDate(day: log.timestamp ?? Date())
        } catch {
//                Replace this implementation with code to handle the error appropriately.
//                fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct TimeEditView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEditView(timeUtils: TimeHelper(), dataUtils: DataManager(), log: Log())
    }
}
