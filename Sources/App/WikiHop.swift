import SwiftUI

public struct WikiHopApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AppView()
                .with(engine: .system)
        }
    }
}
