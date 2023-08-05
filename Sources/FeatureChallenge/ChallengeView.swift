//
//  ChallengeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import HopKit

import LibEngine

public struct ChallengeView: View {
    @Environment(\.engine) var engine
    @State var clicks = -1
    @State var searchQuery = ""
    @State var hasWon = false

    var challenge: Challenge

    public init(challenge: Challenge) {
        self.challenge = challenge
    }

    public var body: some View {
        WebView(engineViewFactory: engine.viewFactory)
            .overlay(alignment: .topLeading) {
                if clicks >= 0 {
                    Text("\(clicks)")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(clicks)")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("0")
                        .transition(.push(from: .leading).combined(with: .scale))
                        .id("click\(clicks)")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    TextField("Search term", text: $searchQuery)
                    Button(action: {
                        engine.dispatch(.findInPage(.findPrevious(searchQuery)))
                    }) {
                        Image(systemName: "chevron.up").padding()
                    }
                    Button(action: {
                        engine.dispatch(.findInPage(.findNext(searchQuery)))
                    }) {
                        Image(systemName: "chevron.down").padding()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))
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
