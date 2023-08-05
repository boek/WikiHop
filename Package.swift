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
        .library(name: "LibHopClient", targets: ["LibHopClient"]),

        .library(name: "FeatureChallenge", targets: ["FeatureChallenge"]),
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
        .library(name: "FeatureOnboarding", targets: ["FeatureOnboarding"]),
    ],
    dependencies: [.package(url: "https://github.com/supabase/supabase-swift.git", from: "0.3.0")],
    targets: [
        .target(name: "App", dependencies: [
            "HopKit",

            "LibAuth",
            "LibEngine",
            "LibHopClient",

            "FeatureOnboarding",
            "FeatureHome",
            "FeatureChallenge",
        ]),

        .target(name: "LibAuth"),
        .target(name: "LibHopClient", dependencies: [
            "HopKit",
            .product(name: "Supabase", package: "supabase-swift")
        ]),
        .target(
            name: "LibEngine",
            resources: [
                .process("Resources/findInPage.js"),
                .process("Resources/wikipediaUserStyles.js"),
            ]
        ),

        .target(name: "FeatureChallenge", dependencies: [
            "LibEngine",
            "HopKit"
        ]),
        .target(name: "FeatureHome", dependencies: [
            "HopKit",
            "LibHopClient"
        ]),
        .target(name: "FeatureOnboarding", dependencies: ["LibAuth"]),

        .target(name: "HopKit")
    ]
)
