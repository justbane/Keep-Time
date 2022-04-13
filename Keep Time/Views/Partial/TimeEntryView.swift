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
    @State var showingTags: Bool = false
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    let day: Date
    
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
                
                HStack {
                    Text("Note: ")
                    TextEditor(text: $note)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .font(.title2)
                }
                .frame(width: 400, height: 22)
                .padding(.leading, 10)
                
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
                    addTime()
                } label: {
                    Text("Add Time").font(.body)
                }
            }.onAppear(perform: {
                dataUtils.setTheDay(day: day)
            }).font(.title3)
                .padding(.bottom, 5)
            
            Spacer()
//            Add preference pane for time entry
//            Text(timeUtils.getTime(seconds: Int(startDate.distance(to: endDate))))
            Text(timeUtils.getTime(seconds: selectedTime))
            
        }
        .frame(height: 65)
        .font(.title2)
        .padding()
        
    }
    
    private func addTime() {
//        Add preference pane for time entry
//        selectedTime = Int(startDate.distance(to: endDate))
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
//                    Replace this implementation with code to handle the error appropriately.
//                    fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
                note = ""
                selectedTime = 0
                selectedType = 1
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
