// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Helpers",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(
            name: "Helpers",
            targets: [
                "Shaders",
                "Ranges",
                "Shortcuts",
                "ImageCompression",
                "HoverAsync",
                "Formatting",
                "DebugFrames",
                "Colour",
                "Clipboard",
                "BaseHelpers",
                "Algorithms",
            ]
        )
    ],
    targets: [
        .target(name: "Shaders"),
        .target(name: "Ranges"),
        .target(name: "Shortcuts"),
        .target(name: "ImageCompression"),
        .target(name: "HoverAsync"),
        .target(name: "Formatting"),
        .target(name: "DebugFrames"),
        .target(name: "Colour", dependencies: ["BaseHelpers"]),
        .target(name: "Clipboard"),
        .target(name: "BaseHelpers"),
        .target(name: "Algorithms"),

    ]
)
