//
//  UtilizationView.swift
//  Keep Time
//
//  Created by Justin Bane on 2/6/22.
//

import SwiftUI

struct UtilizationView: View {
    
    @State private var color = Color(.green)
    @State var seconds = 0.0
    @ObservedObject var dataUtils: DataManager
    let workDaySeconds = 28800 // seconds in 8 hours, Should go in preferences
    
    var body: some View {
        BarGraph(total: Double(workDaySeconds), billable: Double(dataUtils.billableSeconds), all: Double(dataUtils.todaysSeconds))
    }
}

struct UtilizationView_Previews: PreviewProvider {
    static var previews: some View {
        UtilizationView(dataUtils: DataManager())
    }
}
