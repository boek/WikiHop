//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/5/23.
//

import Foundation
import SwiftUI

struct HopClientEnvironmentKey: EnvironmentKey {
    static var defaultValue: HopClient { .test }
}

extension EnvironmentValues {
    var hopClient: HopClient {
        get { self[HopClientEnvironmentKey.self] }
        set { self[HopClientEnvironmentKey.self] = newValue }
    }
}


@propertyWrapper
public struct UseHopClient: DynamicProperty {
    @Environment(\.hopClient) var hopClient
    public var wrappedValue: HopClient { hopClient }

    public init() {}
}
