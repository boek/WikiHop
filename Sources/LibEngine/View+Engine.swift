//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation
import SwiftUI

public extension View {
    func with(engine: Engine) -> some View {
        environment(\.engine, engine)
    }
}

