//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/5/23.
//

import Foundation
import HopKit
import Supabase

extension PostgrestClient {
    var getCurrentChallenge: PostgrestTransformBuilder {
        from("challenges")
            .select()
            .single()
    }
}

public typealias HopClientKey = String

public struct HopClient {
    public var getCurrentChallenge: () async throws -> Challenge
}

public extension HopClient {
    static var test: HopClient {
        HopClient(
            getCurrentChallenge: { .test }
        )
    }

    static func live(
        url: URL,
        key: HopClientKey
    ) -> HopClient {
        let client = SupabaseClient(supabaseURL: url, supabaseKey: key)

        return HopClient(
            getCurrentChallenge: {
                let challenge: Challenge = try await client.database.getCurrentChallenge.execute().value

                return challenge
            }
        )
    }
}
