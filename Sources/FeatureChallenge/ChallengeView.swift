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

extension Journey {
    var clicks: Int { steps.count }
}

public struct ChallengeView: View {
    @Environment(\.engine) var engine
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.currentChallenge) var challenge
    @UseHopClient var hopClient
    @Binding var journey: Journey
    @State var searchQuery = ""
    @State var hasWon = false
    
    public init(journey: Binding<Journey>) {
        self._journey = journey
    }
    
    public var body: some View {
        let searchBarBackgroundColor = Color.black.opacity(0.75)
        let searchContainerBackgroundColor = Color.black.opacity(0.7)
        
        WebView(engineViewFactory: engine.viewFactory)
            .overlay(alignment: .topTrailing) {
                if journey.clicks >= 0 {
                    Text("\(journey.clicks)")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(journey.clicks)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                } else {
                    Text("0")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(journey.clicks)")
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
                        .background(searchBarBackgroundColor)
                        .cornerRadius(55)
                        .font(.system(size: 20, weight: .heavy, design: .default))
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, -10)
                .background(searchContainerBackgroundColor)
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
                guard let url = URL(string: "https://en.wikipedia.org/wiki/\(challenge.from.id)") else { return }
                engine.dispatch(.load(URLRequest(url: url)))
            }
            .task {
                for await event in engine.events {
                    if case EngineEvent.urlDidChange(let url) = event, let url {
                        withAnimation {
                            journey.steps.append(Step(date: .now, page: Page(id: url.lastPathComponent)))
                            hasWon = url.relativePath.contains(challenge.to.id) == true
                        }
                        if (hasWon) {
                            let userId = UUID(uuidString:"ff24d3a3-7740-4433-8e1f-f9d5d8eef1b5")!
                            let challengeId = UUID(uuidString: "319140d6-8fb3-42f9-be79-551ad7554aa0")!
                            do {
                                try await hopClient.insertJourney(userId, challengeId, journey.clicks, journey.startedAt, Date.now)
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
        ChallengeView(journey: .constant(.init(challengeId: UUID())))
    }
}
