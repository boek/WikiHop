//
//  HomeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

import HopKit
import LibHopClient

public struct HomeView: View {
    @Environment(\.currentChallenge) var challenge
    @Environment(\.startGameAction) var startGame
    @State var showHowToPlay = false

    public init() {}

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("WikiHop")
                    .font(.system(.title, design: .serif))
                Spacer()
            }.overlay(alignment: .trailing) {
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                }
            }

            Spacer()

            Text(challenge.from.title)
                .font(.largeTitle)
            Text("to")
            Text(challenge.to.title)
                .font(.largeTitle)

            Spacer()

            Button(action: startGame) {
                HStack {
                    Spacer()
                    Text("Hop").bold()
                    Spacer()
                }
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)

            Button(action: { self.showHowToPlay.toggle() }) {
                Text("How to play")
            }
        }
        .padding()
        .tint(.primary)
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
