//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/6/23.
//

import Foundation
import SwiftUI


// MARK: StartGameAction
public typealias StartGameAction = () -> Void

struct StartGameEnvironmentKey: EnvironmentKey {
    static var defaultValue: StartGameAction { {} }
}

public extension EnvironmentValues {
    var startGameAction: StartGameAction {
        get { self[StartGameEnvironmentKey.self] }
        set { self[StartGameEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func with(startGameAction: @escaping StartGameAction) -> some View {
        environment(\.startGameAction, startGameAction)
    }
}
