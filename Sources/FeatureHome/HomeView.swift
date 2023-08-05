//
//  HomeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import WikiKit

extension URL {
    var title: String {
        lastPathComponent.replacingOccurrences(of: "_", with: " ")
    }
}

public struct HomeView: View {
    @State var showHowToPlay = false
    var startGame: () -> Void
    var challenge = Challenge.test

    public init(startGame: @escaping () -> Void = {}) {
        self.startGame = startGame
    }

    public var body: some View {
        VStack {
            Text("WikiHop")
                .font(.largeTitle)

            Spacer()

            Text(challenge.start.title)
                .font(.largeTitle)
            Text("to")
            Text(challenge.end.title)
                .font(.largeTitle)

            Spacer()

            Button(action: startGame) {
                Text("Go")
            }.buttonStyle(.borderedProminent)

            Button(action: { self.showHowToPlay.toggle() }) {
                Text("How to play")
            }
        }
        .padding()
        .sheet(isPresented: $showHowToPlay) {
            HowToPlayView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
