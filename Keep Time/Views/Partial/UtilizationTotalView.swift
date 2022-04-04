//
//  UtilizationTotalView.swift
//  Keep Time
//
//  Created by Justin Bane on 4/3/22.
//

import SwiftUI

struct UtilizationTotalView: View {
    
    @ObservedObject var dataUtils: DataManager
    
    var body: some View {
        HStack {
            UtilizationView(dataUtils: dataUtils)
            .padding()
            VStack(alignment: .leading) {
                Text("Total: ").font(.title)
                Text(dataUtils.todaysTotal)
            }
        }
    }
}

struct UtilizationTotalView_Previews: PreviewProvider {
    static var previews: some View {
        UtilizationTotalView(dataUtils: DataManager())
    }
}
