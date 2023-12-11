// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WelcomeKit",
    platforms: [.macOS(.v12)],

    products: [
        .library(
            name: "WelcomeKit",
            targets: ["WelcomeKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WelcomeKit",
            dependencies: [
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "WelcomeKitTests",
            dependencies: ["WelcomeKit"]
        ),
    ]
)
