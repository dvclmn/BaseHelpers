// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Styles",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(name: "BaseStyles", targets: ["BaseStyles"]),
        .library(name: "GrainOverlay", targets: ["GrainOverlay"]),
        .library(name: "Swatches", targets: ["Swatches"]),
    ],
    targets: [
      .target(name: "BaseStyles", dependencies: ["GrainOverlay", "Swatches"]),
      .target(name: "GrainOverlay", resources: [.copy("Assets.xcassets")]),
      .target(name: "Swatches"),
    ]
)
