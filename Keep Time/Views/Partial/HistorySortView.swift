//
//  HistorySortView.swift
//  Keep Time
//
//  Created by Justin Bane on 12/4/21.
//

import SwiftUI

struct HistorySortView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var timeUtils: TimeHelper
    @ObservedObject var dataUtils: DataManager
    
    @State var startDate: Date
    @State var endDate: Date
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .center) {
                    Text("From")
                    DatePicker(selection: $startDate,
                        in: ...Date(),
                        displayedComponents: .date,
                        label: {})
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                }
                VStack {
                    Text("To")
                    DatePicker(selection: $endDate,
                        in: ...Date(),
                        displayedComponents: .date,
                        label: {})
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                }

            }
            Divider()
            Button {
                // Some stuff
                dataUtils.getDaysByDate(from: startDate, to: endDate)
                // dismiss us
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Apply Filter")
            }.padding(.vertical, 10)
                
        }
        
    }
}

struct HistorySortView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySortView(timeUtils: TimeHelper(), dataUtils: DataManager(), startDate: Date(), endDate: Date())
    }
}
