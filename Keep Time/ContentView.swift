//
//  ContentView.swift
//  Keep Time
//
//  Created by Justin Bane on 10/23/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var selected: String = ""
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TimeTodayView()) {
                    Image(systemName: "clock")
                    Text("Today")
                }
                NavigationLink(destination: TimeHistoryView()) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                NavigationLink(destination: Text("Performance")) {
                    Image(systemName: "gauge")
                    Text("Performance")
                }
            }
            .frame(width: 150)
            
            Text("Default View")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
