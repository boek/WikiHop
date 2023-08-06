//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation

public typealias UserID = UUID

public struct Page: Codable {
    public var id: String
    public var title: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(id: try container.decode(String.self))
    }

    public init(id: String) {
        self.id = id
        self.title = id.replacingOccurrences(of: "_", with: " ")
    }

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

public struct Step {
    public var date: Date
    public var page: Page

    public init(date: Date, page: Page) {
        self.date = date
        self.page = page
    }
}



public struct Journey {
    public var challengeId: ChallengeID
    public var startedAt: Date
    public var steps: [Step]

    public init(
        challengeId: ChallengeID,
        startedAt: Date = .now,
        steps: [Step] = []
    ) {
        self.challengeId = challengeId
        self.startedAt = startedAt
        self.steps = steps
    }
}

public typealias JourneyID = UUID
public struct FinishedJourney: Identifiable, Codable {
    public var id: JourneyID
    public var userId: UserID
    public var challengeId: ChallengeID
    public var clicks: Int
    public var startedAt: Date
    public var finishedAt: Date

    public init(
        id: JourneyID,
        userId: UserID,
        challengeId: ChallengeID,
        clicks: Int,
        startedAt: Date,
        finishedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.challengeId = challengeId
        self.clicks = clicks
        self.startedAt = startedAt
        self.finishedAt = finishedAt
    }
}

public extension FinishedJourney {
    static var test: Self {
        .init(
            id: JourneyID(uuidString: "")!,
            userId: UserID(uuidString: "")!,
            challengeId: ChallengeID(uuidString: "F412E1B9-C517-46D8-88D5-1DBC4B7D2AA2")!,
            clicks: 2,
            startedAt: Date.now,
            finishedAt: Date.now
        )
    }
}


public typealias ChallengeID = UUID
public struct Challenge: Identifiable, Codable {
    public var id: ChallengeID
    public var from: Page
    public var to: Page

    public init(
        id: ChallengeID,
        from: Page,
        to: Page
    ) {
        self.id = id
        self.from = from
        self.to = to
    }
}

public extension Challenge {
    static var test: Self {
        .init(
            id: ChallengeID(uuidString: "F412E1B9-C517-46D8-88D5-1DBC4B7D2AA2")!,
            from: Page(id: "Bill_Gates"),
            to: Page(id: "Steve_Jobs")
        )
    }
}
