import SwiftUI

import LibAuth
import LibEngine
import LibWikipediaClient

public struct WikiHopApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AppView()
                .with(engine: .system)
                .with(authClient: .live)
                .with(wikipediaClient: .live)
        }
    }
}
