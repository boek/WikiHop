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
