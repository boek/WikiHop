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

    var challenge: Challenge

    public init(challenge: Challenge) {
        self.challenge = challenge
    }

    public var body: some View {
        WebView(engineViewFactory: engine.viewFactory)
            .onAppear {
                engine.dispatch(.load(URLRequest(url: challenge.start)))
            }
            .task {
                for await event in engine.events {
                    print(event)
                }
            }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: .test)
    }
}
