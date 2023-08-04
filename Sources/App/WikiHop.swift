import SwiftUI
import Supabase

import LibAuth
import LibEngine
import LibHopClient

public struct WikiHopApp: App {
    let client = SupabaseClient.live

    public init() {}

    public var body: some Scene {
        WindowGroup {
            AppView()
                .with(engine: .system)
                .with(authClient: .live)
                .with(hopClient: .live(url: URL(string: "https://mvgfizogxujtoxxskaue.supabase.co")!, key: ""))
        }
    }
}

extension SupabaseClient {
    static var live: Self {
        SupabaseClient(
            supabaseURL: URL(string: "https://mvgfizogxujtoxxskaue.supabase.co")!,
            supabaseKey: ""
        )
    }
}
