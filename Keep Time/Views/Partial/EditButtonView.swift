//
//  EditButtonView.swift
//  Keep Time
//
//  Created by Justin Bane on 4/10/22.
//

import SwiftUI

struct EditButtonView: View {
    @ObservedObject var timeUtils: TimeHelper
    @ObservedObject var dataUtils: DataManager
    
    @State var showingSheet: Bool = false
    let log: Log
    let fontSize: Font
    
    var body: some View {
        Button {
            showingSheet = true
        } label: {
            Text(Image(systemName: "square.and.pencil")).font(fontSize)
        }.sheet(isPresented: $showingSheet) {
            TimeEditView(timeUtils: timeUtils, dataUtils: dataUtils, log: log)
        }
        .buttonStyle(.plain)
    }
}

struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let timeUtils = TimeHelper()
        let dataUtils = DataManager()
        EditButtonView(timeUtils: timeUtils, dataUtils: dataUtils, log: Log(), fontSize: .title2)
    }
}
