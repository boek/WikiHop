//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

struct WikipediaClientEnvironmentKey: EnvironmentKey {
    static var defaultValue: WikipediaClient { .test }
}

public extension EnvironmentValues {
    var wikipediaClient: WikipediaClient {
        get { self[WikipediaClientEnvironmentKey.self] }
        set { self[WikipediaClientEnvironmentKey.self] = newValue }
    }
}
