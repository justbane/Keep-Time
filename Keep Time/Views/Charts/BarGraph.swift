//
//  BarGraph.swift
//  Keep Time
//
//  Created by Justin Bane on 3/12/22.
//

import SwiftUI

struct BarGraph: View {
    
    var total: Double
    var billable: Double
    var all: Double
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center, spacing: 0) {
                Rectangle()
                    .frame(width: metrics.size.width * getPercentage(seconds: billable, total: total), height: 30)
                    .foregroundColor(.green)
                Rectangle()
                    .frame(width: metrics.size.width * getPercentage(seconds: (all - billable), total: total), height: 30)
                    .foregroundColor(.yellow)
            }
        }
        .frame(width: 400, height: 30, alignment: .center)
        .background(Color(.sRGB, red: 64, green: 64, blue: 64, opacity: 0.3))
    }
    
    func getPercentage(seconds: Double, total: Double) -> Double {
        let percent = seconds / total
        return Double(percent)
    }
    
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(total: 28000, billable: 4000, all:9000 )
    }
}
