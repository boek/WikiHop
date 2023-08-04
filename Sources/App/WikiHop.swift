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
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12Z2Zpem9neHVqdG94eHNrYXVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTExODEwMTksImV4cCI6MjAwNjc1NzAxOX0.fgVOUxRc6sWirCxq1LLaS2dGkZQHasQKXse7PxenyW4"
        )
    }
}
