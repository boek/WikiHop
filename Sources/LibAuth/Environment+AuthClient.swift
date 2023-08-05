//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation
import SwiftUI

struct AuthClientEnvironmentKey: EnvironmentKey {
    static var defaultValue: AuthClient { .test }
}

public extension EnvironmentValues {
    var authClient: AuthClient {
        get { self[AuthClientEnvironmentKey.self] }
        set { self[AuthClientEnvironmentKey.self] = newValue }
    }
}
