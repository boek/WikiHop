// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WikiHop",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "FeatureOnboarding", targets: ["FeatureOnboarding"])
    ],
    dependencies: [],
    targets: [
        .target(name: "App", dependencies: ["FeatureOnboarding"]),
        .target(name: "FeatureOnboarding")
    ]
)
