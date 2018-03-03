// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LattnerBot",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "LattnerBot",
            targets: ["LattnerBot"]),
    ],
    dependencies: [
		.package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"), // Shell commands
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"), // CLI tool
        .package(url: "https://github.com/SlackKit/SlackKit.git", from: "4.1.0") // Slack interaction 
    ],
    targets: [
        .target(
            name: "LattnerBot",
            dependencies: ["Commander", "ClocWrapper", "Output"]),
        .target(
            name: "ClocWrapper",
            dependencies: ["ShellOut"]),
        .target(
            name: "Output",
            dependencies: ["SlackKit"]),
        .testTarget(
            name: "ClocWrapperTests",
            dependencies: ["ClocWrapper"]),
        .testTarget(
            name: "OutputTests",
            dependencies: ["Output"]),
    ]
)
