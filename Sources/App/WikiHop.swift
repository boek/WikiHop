import SwiftUI

import FeatureOnboarding

public struct WikiHopApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
