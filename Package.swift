// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WikiHop",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "WikiKit", targets: ["WikiKit"]),

        .library(name: "FeatureChallenge", targets: ["FeatureChallenge"]),
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
        .library(name: "FeatureOnboarding", targets: ["FeatureOnboarding"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "App", dependencies: [
            "WikiKit",
            
            "FeatureOnboarding",
            "FeatureHome",
            "FeatureChallenge",
        ]),

        .target(name: "FeatureChallenge", dependencies: ["WikiKit"]),
        .target(name: "FeatureHome", dependencies: ["WikiKit"]),
        .target(name: "FeatureOnboarding"),

        .target(name: "WikiKit")
    ]
)
