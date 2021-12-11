//
//  TimeHistory.swift
//  Keep Time
//
//  Created by Justin Bane on 11/7/21.
//

import SwiftUI
import SwiftDate

struct TimeHistoryView: View {
    
    private var formatter = Formatter()
    private var filterText = "Last 30 days"
    @StateObject var timeUtils = TimeHelper()
    @StateObject var dataUtils = DataManager()
    @State var expanded: Bool = false
    @State var selected: Bool = false
    @State var selectedDate = Date()
    @State var sortShowing: Bool = false
    
    var body: some View {
        VStack {
            // Need date sorting here
            NavigationView {
                listView
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if dataUtils.daysInReport.isEmpty {
            VStack {
                Spacer()
                Text("Nothing here...").font(.title)
                Text("Get to work!!").font(.headline)
                Spacer()
            }
        } else {
            VStack {
                Button(action: {
                    sortShowing = true
                }, label: {
                    Image(systemName: "calendar")
                    Text("Filter")
                })
                    .buttonStyle(.borderless)
                    .padding(.top, 10)
                    .popover(isPresented: $sortShowing) {
                        HistorySortView(
                            timeUtils: timeUtils,
                            dataUtils: dataUtils,
                            startDate: dataUtils.dayRanges.from,
                            endDate: dataUtils.dayRanges.to)
                    }
                Text("\(formatter.formatDateString(date: dataUtils.dayRanges.from)) - \(formatter.formatDateString(date: dataUtils.dayRanges.to))")
                    .padding(.bottom, 10)
                    .font(.callout)
                
                Divider()
                
                List {
                    ForEach(dataUtils.daysInReport, id: \.self) { day in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                NavigationLink(destination: {
                                    TimeHistoryListView(dataUtils: dataUtils, timeUtils: timeUtils, day: day)
                                        .onAppear {
                                            dataUtils.getLogsForDate(day: day)
                                        }
                                }) {
                                    Text(formatter.formatDateString(date: day))
                                        .padding(5)
                                }
                                Divider()
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

struct TimeHistory_Previews: PreviewProvider {
    static var previews: some View {
        TimeHistoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
