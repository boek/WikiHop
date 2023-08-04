//
//  HomeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

public struct HomeView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("WikiHop")
                .font(.largeTitle)

            Spacer()

            Button(action: {}) {
                Text("Go")
            }.buttonStyle(.borderedProminent)

            Button(action: {}) {
                Text("How to play")
            }
        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
