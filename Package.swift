// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(name: "Utilities", targets: [
            "DragToSelect",
            "MultiSelect",
            "PerformanceMonitor",
            "ReadSize",
            "Scrolling",
            "Renamable",
            "WindowSize",
            "Syntax",
            "Resizable",
        ]),
    ],
    dependencies: [
        .package(name: "TestStrings", path: "../TestStrings"),
        .package(name: "Helpers", path: "../Helpers"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.3"),
        .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
        .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "DragToSelect", dependencies: ["Helpers", "ReadSize", "Scrolling"]),
        .target(name: "MultiSelect"),
        .target(name: "PerformanceMonitor"),
        .target(name: "Scrolling", dependencies: ["ScrollKit", .product(name: "SmoothGradient", package: "SmoothGradient")]),
        .target(name: "ReadSize"),
        .target(name: "WindowSize", dependencies: [.product(name: "Dependencies", package: "swift-dependencies")]),
        .target(name: "Renamable"),
        .target(name: "Syntax"),
        .target(name: "Resizable", dependencies: ["Helpers", "TestStrings", "ReadSize"]),
    ]
)


