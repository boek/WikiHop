//
//  SwiftUIView.swift
//  
//
//  Created by Maxwell DeMaio on 8/6/23.
//

import SwiftUI

struct LeaderBoardView: View {
    // Date range from beginning of challenges to current day
    @State private var date = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 8, day: 4)
        let endComponents = Date()
        return calendar.date(from: startComponents)! ... endComponents
    }()
    
    var body: some View {
        VStack {
            Text("Leader Board View")
            DatePicker(
                "Challenge Day",
                 selection: $date,
                 in: dateRange,
                 displayedComponents: [.date]
            )
            
            Text("Hello, Leader Board!")
            Text("Player1")
            Text("Player2")
            Text("Player3")
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
