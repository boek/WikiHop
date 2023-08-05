//
//  OnboardingView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import LibAuth

public struct OnboardingView: View {
    @Environment(\.authClient) var authClient

    var onTap: () -> Void

    public init(onTap: @escaping () -> Void = {}) {
        self.onTap = onTap
    }

    public var body: some View {
        VStack {
            Text("Onboarding")
            Button(action: onTap) {
                Text("Onboard")
            }
            Button(action: {
                Task {
                    print(try? await authClient.authorize())
                }
            }) {
                Text("Continue with Apple")
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
