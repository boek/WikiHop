//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation

public struct Challenge {

    public var start: URL
    public var end: URL

    public init(start: URL, end: URL) {
        self.start = start
        self.end = end
    }
}

public extension Challenge {
    static var test: Self {
        .init(
            start: URL(string: "https://en.wikipedia.org/wiki/Bill_Gates")!,
            end: URL(string: "https://en.wikipedia.org/wiki/Steve_Jobs")!
        )
    }
}
