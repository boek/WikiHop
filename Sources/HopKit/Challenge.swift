//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation

public typealias ChallengeID = UUID
public struct Challenge: Identifiable, Codable {
    public var id: ChallengeID
    public var from: String
    public var to: String

    public init(
        id: ChallengeID,
        from: String,
        to: String
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
            from: "Bill_Gates",
            to: "Steve_Jobs"
        )
    }
}
