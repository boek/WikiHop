//
//  File.swift
//  
//
//  Created by Dan Stepanov on 8/5/23.
//

import Foundation

public typealias JourneyID = UUID
public typealias UserID = UUID

public struct Journey: Identifiable, Codable {
    public var id: JourneyID
    public var userId: UserID
    public var challengeId: ChallengeID
    public var clicks: Int
    public var finishedAt: Date

    public init(
        id: JourneyID,
        userId: UserID,
        challengeId: ChallengeID,
        clicks: Int,
        finishedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.challengeId = challengeId
        self.clicks = clicks
        self.finishedAt = finishedAt
    }
}

public extension Journey {
    static var test: Self {
        .init(
            id: JourneyID(uuidString: "")!,
            userId: UserID(uuidString: "")!,
            challengeId: ChallengeID(uuidString: "F412E1B9-C517-46D8-88D5-1DBC4B7D2AA2")!,
            clicks: Int(2),
            finishedAt: Date.now
        )
    }
}
