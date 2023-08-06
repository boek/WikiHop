import SwiftUI
import LibHopClient

import LibAuth
import LibEngine
import LibHopClient

public struct WikiHopApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AppView()
                .withCurrentChallenge()
                .with(engine: .system)
                .with(authClient: .live)
                .with(hopClient: .live(url: URL(string: "https://mvgfizogxujtoxxskaue.supabase.co")!, key: ""))
        }
    }
}
