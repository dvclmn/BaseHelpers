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
            "APIHandler",
            "TokenHandler",
            "Shaders",
            "BaseUtilities",
            "HoverAsync",
            "MultiSelect",
            "PerformanceMonitor",
            "ScrollOffset",
            "ReadSize",
            "Renamable",
            "Resizable",
            "ScrollMask",
        ]),
    ],
    dependencies: [
        .package(name: "TestStrings", path: "../TestStrings"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
        .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
        
    ],
    targets: [
        .target(name: "APIHandler", dependencies: ["BaseUtilities", .product(name: "KeychainSwift", package: "keychain-swift")]),
        .target(name: "TokenHandler", dependencies: [.product(name: "KeychainSwift", package: "keychain-swift"), "APIHandler", "BaseUtilities"]),
        .target(name: "Shaders"),
        .target(name: "BaseUtilities", dependencies: ["TestStrings", ]),
        .target(name: "HoverAsync"),
        .target(name: "MultiSelect"),
        .target(name: "PerformanceMonitor"),
        .target(name: "ScrollOffset", dependencies: ["ScrollKit", "ScrollMask"]),
        .target(name: "ReadSize"),
        .target(name: "Renamable"),
        .target(name: "Resizable", dependencies: ["BaseUtilities", "TestStrings", "ReadSize"]),
        .target(name: "ScrollMask", dependencies: ["SmoothGradient"])
    ]
)


