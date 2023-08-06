//
//  SwiftUIView.swift
//  
//
//  Created by Jeff Boek on 8/6/23.
//

import SwiftUI

import HopKit
import LibHopClient

enum CurrentChallengeState {
    case initial
    case loaded(Challenge)
    case failed(Error)
}

struct WithCurrentChallengeViewModifier: ViewModifier {
    @UseHopClient var hopClient
    @State var challengeState = CurrentChallengeState.initial

    func body(content: Content) -> some View {
        switch challengeState {
        case .initial:
            ProgressView()
                .task {
                    do {
                        print("loading")
                        challengeState = .loaded(try await hopClient.getCurrentChallenge())
                        print("challengeState", challengeState)
                    } catch {
                        challengeState = .failed(error)
                    }
                }
        case .loaded(let challenge):
            content
                .with(currentChallenge: challenge)
        case .failed(let error): Text("Failed")
        }
    }
}

extension View {
    func withCurrentChallenge() -> some View {
        modifier(WithCurrentChallengeViewModifier())
    }
}
