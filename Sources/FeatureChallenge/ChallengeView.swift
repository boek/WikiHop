//
//  ChallengeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import WikiKit

public struct ChallengeView: View {
    var challenge: Challenge

    public init(challenge: Challenge) {
        self.challenge = challenge
    }

    public var body: some View {
        Text("Hello, World!")
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: .test)
    }
}
