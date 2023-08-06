//
//  AppView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

import HopKit

import FeatureChallenge
import FeatureHome

@available(macOS 10.15, *)
struct AppView: View {
    @State var hasOnboarded = false
    @State var currentChallenge: Challenge?

    var body: some View {
        if let currentChallenge {
            ChallengeView(challenge: currentChallenge)
        } else {
            HomeView()
                .with(startGameAction: { self.currentChallenge = .test })
        }
    }
}
@available(macOS 10.15, *)
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
