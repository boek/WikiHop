//
//  ChallengeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import WikiKit

import LibEngine

public struct ChallengeView: View {
    @Environment(\.engine) var engine
    @State var clicks = -1
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
            .onAppear {
                engine.dispatch(.load(URLRequest(url: challenge.start)))
            }
            .task {
                for await event in engine.events {
                    if event == .didFinishNavigation {
                        withAnimation { self.clicks += 1 }
                    }
                }
            }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: .test)
    }
}
