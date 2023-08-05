//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/5/23.
//

import SwiftUI

public extension View {
    func with(hopClient: HopClient) -> some View {
        environment(\.hopClient, hopClient)
    }
}
