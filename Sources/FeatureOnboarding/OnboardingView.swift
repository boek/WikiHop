//
//  OnboardingView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

public struct OnboardingView: View {
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
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
