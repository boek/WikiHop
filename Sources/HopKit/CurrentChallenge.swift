//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/6/23.
//

import Foundation
import SwiftUI

struct CurrentChallengeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Challenge { .test }
}

public extension EnvironmentValues {
    var currentChallenge: Challenge {
        get { self[CurrentChallengeEnvironmentKey.self] }
        set { self[CurrentChallengeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func with(currentChallenge: Challenge) -> some View {
        environment(\.currentChallenge, currentChallenge)
    }
}
