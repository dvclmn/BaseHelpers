// swift-tools-version: 5.10

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "Collection",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    
    /// Styles
    .library(name: "BaseStyles", targets: [
      "BaseStyles",
      "Grainient"
    ]),

    /// Utilities
    .library(name: "Utilities", targets: [
      "GlyphGrid",
    ]),
    
    /// Helpers
    .library(
      name: "BaseHelpers",
      targets: [
        "BaseHelpers",
        "Shaders",
        "Shortcuts",
      ]
    ),
    
    /// Networking
    .library(
      name: "Networking",
      targets: [
        "APIHandler",
      ]
    ),
    
  ],
  dependencies: [
    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", from: "0.5.0"),
  ],
  
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("GrainOverlay/Assets.xcassets")]),
    .target(name: "Grainient", dependencies: ["BaseStyles"]),
    
    /// Utilities
    .target(name: "GlyphGrid", dependencies: ["BaseHelpers"]),

    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts", dependencies: ["BaseHelpers"]),
    
    /// Networking
    .target(name: "APIHandler", dependencies: [
      "BaseHelpers",
      .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro")
    ]),

    
  ]
)

let swiftSettings: [SwiftSetting] = [
  .enableExperimentalFeature("StrictConcurrency"),
  .enableUpcomingFeature("DisableOutwardActorInference"),
  .enableUpcomingFeature("InferSendableFromCaptures"),
  .enableUpcomingFeature("BareSlashRegexLiterals")
]

for target in package.targets {
  var settings = target.swiftSettings ?? []
  settings.append(contentsOf: swiftSettings)
  target.swiftSettings = settings
}
