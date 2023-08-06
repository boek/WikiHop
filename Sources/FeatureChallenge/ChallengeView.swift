//
//  ChallengeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import HopKit

import LibHopClient
import LibEngine

public struct ChallengeView: View {
    @Environment(\.engine) var engine
    @Environment(\.colorScheme) var colorScheme
    @State var clicks = -1
    @State var searchQuery = ""
    @State var hasWon = false
    @UseHopClient var hopClient

    var challenge: Challenge

    public init(challenge: Challenge) {
        self.challenge = challenge
    }

    public var body: some View {
        WebView(engineViewFactory: engine.viewFactory)
            .overlay(alignment: .topTrailing) {
                if clicks >= 0 {
                    Text("\(clicks)")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(clicks)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                } else {
                    Text("0")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(clicks)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    TextField("Search", text: $searchQuery)
                        .foregroundColor(.white)
                        .disableAutocorrection(true)
                        .safeAreaInset(edge: .leading) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .padding(0.5)
                                .bold()
                        }
                        .accentColor(.white)
                        .padding(.all, 20)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(55)
                        .font(.system(size: 20, weight: .heavy, design: .default))
                    Button(action: {
                        engine.dispatch(.findInPage(.findPrevious(searchQuery)))
                    }) {
                        Image(systemName: "chevron.up").padding().foregroundColor(.white)
                    }
                    Button(action: {
                        engine.dispatch(.findInPage(.findNext(searchQuery)))
                    }) {
                        Image(systemName: "chevron.down").padding().foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.4))
            }
            .overlay {
                if hasWon {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            Text("🎉")
                                .font(.largeTitle)
                        }
                }
            }
            .onAppear {
                guard let url = URL(string: "https://en.wikipedia.org/wiki/\(challenge.from)") else { return }
                engine.dispatch(.load(URLRequest(url: url)))
            }
            .task {
                for await event in engine.events {
                    if event == .didFinishNavigation {
                        withAnimation { self.clicks += 1 }
                    }

                    if case EngineEvent.urlDidChange(let url) = event {
                        withAnimation {
                            hasWon = url?.relativePath.contains(challenge.to) == true
                        }
                        if (hasWon) {
                            let userId = UUID(uuidString:"ff24d3a3-7740-4433-8e1f-f9d5d8eef1b5")!
                            let challengeId = UUID(uuidString: "319140d6-8fb3-42f9-be79-551ad7554aa0")!
                            do {
                                try await hopClient.insertJourney(userId, challengeId, clicks, Date.now)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .onChange(of: self.searchQuery) { query in
                engine.dispatch(.findInPage(.updateQuery(query)))
            }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: .test)
    }
}
