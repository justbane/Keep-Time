//
//  Keep_TimeApp.swift
//  Keep Time
//
//  Created by Justin Bane on 10/23/21.
//
import SwiftUI

@main
struct Keep_TimeApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
