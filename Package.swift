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
      "Profiler",
      "Renamable",
      "Resizable",
      "GlyphGrid",
      "Scrolling",
      "Selection",
      "PathDebugger"
    ]),
    
    /// Helpers
    .library(
      name: "BaseHelpers",
      targets: [
        "BaseHelpers",
        "ImageCompression",
        "Shaders",
        "TouchInertia",
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
//    .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
    .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
    
    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", from: "0.5.0"),
  ],
  
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("GrainOverlay/Assets.xcassets")]),
    .target(name: "Grainient", dependencies: ["BaseStyles"]),
    
    /// Utilities
    .target(name: "Profiler"),
    .target(name: "Renamable"),
    .target(name: "PathDebugger"),
    .target(name: "GlyphGrid", dependencies: ["BaseHelpers"]),
    .target(name: "Resizable", dependencies: ["BaseHelpers", "Shortcuts"]),
    .target(name: "Scrolling", dependencies: [.product(name: "SmoothGradient", package: "SmoothGradient")]),
    .target(name: "Selection", dependencies: ["BaseHelpers", "Scrolling"]),

    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "ImageCompression"),
    .target(name: "TouchInertia"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts", dependencies: ["BaseHelpers"]),
    
    /// Networking
    .target(name: "APIHandler", dependencies: [
      "BaseHelpers",
//      .product(name: "KeychainSwift", package: "keychain-swift"),
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
