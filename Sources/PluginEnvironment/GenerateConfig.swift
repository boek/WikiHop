//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/6/23.
//

import Foundation
import ArgumentParser

@main
struct GenerateConfig: ParsableCommand {
    @Option(name: .shortAndLong) var input: String
    @Option(name: .shortAndLong) var output: String

    mutating func run() throws {
        let contents = try String(contentsOfFile: input)
        let pieces = contents.split(whereSeparator: \.isNewline).map {
            let parts = $0.split(whereSeparator: { $0 == "="})
            return "static let \(parts[0]) = \"\(parts[1])\""
        }

        try """
        struct Config {
            \(pieces.joined(separator: "\n    "))
        }
        """.write(toFile: output, atomically: true, encoding: .utf8)
    }
}


