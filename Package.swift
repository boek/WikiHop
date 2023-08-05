// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WikiHop",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "HopKit", targets: ["HopKit"]),

        .library(name: "LibAuth", targets: ["LibAuth"]),
        .library(name: "LibEngine", targets: ["LibEngine"]),
        .library(name: "LibWikipediaClient", targets: ["LibWikipediaClient"]),

        .library(name: "FeatureChallenge", targets: ["FeatureChallenge"]),
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
        .library(name: "FeatureOnboarding", targets: ["FeatureOnboarding"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "App", dependencies: [
            "HopKit",

            "LibAuth",
            "LibEngine",
            "LibWikipediaClient",

            "FeatureOnboarding",
            "FeatureHome",
            "FeatureChallenge",
        ]),

        .target(name: "LibAuth"),
        .target(
            name: "LibEngine",
            resources: [
                .process("Resources/findInPage.js"),
                .process("Resources/wikipediaUserStyles.js"),
            ]
        ),
        .target(name: "LibWikipediaClient"),
        .testTarget(name: "LibWikipediaClientTests", dependencies: ["LibWikipediaClient"]),

        .target(name: "FeatureChallenge", dependencies: [
            "LibEngine",
            "LibWikipediaClient",
            "HopKit"
        ]),
        .target(name: "FeatureHome", dependencies: ["HopKit"]),
        .target(name: "FeatureOnboarding", dependencies: ["LibAuth"]),

        .target(name: "HopKit")
    ]
)
