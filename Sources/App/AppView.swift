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

struct AppView: View {
    @State var hasOnboarded = false
    @State var journey: Journey? = nil
    @Environment(\.currentChallenge) var currentChallenge

    var body: some View {
        if let journey = Binding($journey) {
            ChallengeView(journey: journey)
        } else {
            HomeView()
                .with(startGameAction: { self.journey = Journey(challengeId: currentChallenge.id) })
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
