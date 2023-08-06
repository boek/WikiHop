//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/6/23.
//

import Foundation
import PackagePlugin

@main
struct GenerateEnvironmentPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let outputFile = context.pluginWorkDirectory.appending("Generated.swift")
        return [
            .buildCommand(
                displayName: "Create Config",
                executable: try context.tool(named: "PluginEnvironment").path,
                arguments: [
                    "--input",
                    context.package.directory.appending(".env").string,
                    "--output",
                    outputFile.string
                ],
                outputFiles: [
                    outputFile
                ]
            )
        ]
    }
}
