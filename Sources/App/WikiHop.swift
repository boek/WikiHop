import SwiftUI

import LibEngine
import LibAuth

public struct WikiHopApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AppView()
                .with(engine: .system)
                .with(authClient: .live)
        }
    }
}
