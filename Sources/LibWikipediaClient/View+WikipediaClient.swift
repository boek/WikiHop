//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

public extension View {
    func with(wikipediaClient: WikipediaClient) -> some View {
        environment(\.wikipediaClient, wikipediaClient)
    }
}
