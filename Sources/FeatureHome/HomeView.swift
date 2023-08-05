//
//  HomeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

import HopKit
import LibHopClient

extension String {
    var title: String {
        replacingOccurrences(of: "_", with: " ")
    }
}

public struct HomeView: View {
    @State var showHowToPlay = false
    @UseHopClient var hopClient
    @State var challenge: Challenge?
    var startGame: () -> Void


    public init(startGame: @escaping () -> Void = {}) {
        self.startGame = startGame
    }

    public var body: some View {
        if let challenge {
            VStack {
                Text("WikiHop")
                    .font(.largeTitle)

                Spacer()

                Text(challenge.from.title)
                    .font(.largeTitle)
                Text("to")
                Text(challenge.to.title)
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
        } else {
            Color.clear
                .task {
                    do {
                        self.challenge = try await hopClient.getCurrentChallenge()
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
