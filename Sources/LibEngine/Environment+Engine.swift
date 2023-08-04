//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation
import SwiftUI

struct EngineEnvironmentKey: EnvironmentKey {
    static var defaultValue: Engine { .test }
}

public extension EnvironmentValues {
    var engine: Engine {
        get { self[EngineEnvironmentKey.self] }
        set { self[EngineEnvironmentKey.self] = newValue }
    }
}
