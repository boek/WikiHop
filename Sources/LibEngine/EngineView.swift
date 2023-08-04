//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/29/22.
//

import SwiftUI

public struct WebView: UIViewRepresentable {
    let engineViewFactory: EngineViewFactory

    public init(
        engineViewFactory: EngineViewFactory
    ) {
        self.engineViewFactory = engineViewFactory
    }

    public func makeUIView(context: Context) -> UIView {
        return engineViewFactory()
    }

    public func updateUIView(_ uiView: UIView, context: Context) { }
}
