//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/5/23.
//

import Foundation
import HopKit
import Supabase

struct InsertJourney: Codable {
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case challengeId = "challenge_id"
        case clicks
        case finishedAt = "finished_at"
    }
    let userId: UUID
    let challengeId: UUID
    let clicks: Int
    let finishedAt: Date
}

extension PostgrestClient {
    var getCurrentChallenge: PostgrestTransformBuilder {
        from("challenges")
            .select()
            .single()
    }
    
    func insertJourney(userId: UUID, challengeId: UUID, clicks: Int, finishedAt: Date) -> PostgrestTransformBuilder {
        let toInsert = InsertJourney(userId: userId, challengeId: challengeId, clicks: clicks, finishedAt: finishedAt)
        
        let insertedJourney = from("journeys").insert(values: toInsert).single()
        return insertedJourney
    }
}

public typealias HopClientKey = String

public struct HopClient {
    public var getCurrentChallenge: () async throws -> Challenge
    public var insertJourney: (UUID, UUID, Int, Date) async throws -> Void
}

public extension HopClient {
    static var test: HopClient {
        HopClient(
            getCurrentChallenge: { .test },
            insertJourney: { _, _, _, _ in }
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
            },
            insertJourney: { userId, challengeId, clicks, finishedAt in
                
                let insertJourney = client.database.insertJourney(userId: userId, challengeId: challengeId, clicks: clicks, finishedAt: finishedAt)
                let insertedJourney = try await insertJourney.execute()
                print("Successfully inserted Journey: \(insertedJourney)")
            }
        )
    }
}
