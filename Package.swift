// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WikiHop",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "WikiKit", targets: ["WikiKit"]),
        .library(name: "FeatureOnboarding", targets: ["FeatureOnboarding"]),
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "App", dependencies: [
            "FeatureOnboarding",
            "FeatureHome"
        ]),
        .target(name: "FeatureOnboarding"),
        .target(name: "FeatureHome"),

        .target(name: "WikiKit")
    ]
)
