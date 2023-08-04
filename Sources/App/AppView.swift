//
//  AppView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

import WikiKit

import FeatureChallenge
import FeatureHome
import FeatureOnboarding

struct AppView: View {
    @State var hasOnboarded = false
    @State var currentChallenge: Challenge?

    var body: some View {
        ChallengeView(challenge: .test)
//        if hasOnboarded {
//            if let currentChallenge {
//
//            } else {
//                HomeView {
//                    self.currentChallenge = .test
//                }
//            }
//        } else {
//            OnboardingView {
//                self.hasOnboarded.toggle()
//            }
//        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
