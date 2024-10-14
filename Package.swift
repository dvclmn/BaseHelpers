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
      "Geometry",
      "TapOffToDismiss",
      "Profiler",
      "Renamable",
      "Logging",
      "Resizable",
      "GlyphGrid",
      "Scrolling",
      "Selection",
      "FocusHelper",
    ]),
    
    /// Helpers
    .library(
      name: "BaseHelpers",
      targets: [
        "BaseHelpers",
        "HoverAsync",
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
        "Keychain",
      ]
    ),
    
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.15.0"),
    .package(url: "https://github.com/dvclmn/TextCore.git", branch: "main"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.4.0"),
    .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
    .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", from: "0.5.0")
  ],
  
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("GrainOverlay/Assets.xcassets")]),
    .target(name: "Grainient", dependencies: ["BaseStyles"]),
    
    /// Utilities
    .target(name: "Geometry", dependencies: [.product(name: "Dependencies", package: "swift-dependencies")]),
    .target(name: "TapOffToDismiss", dependencies: ["BaseHelpers", "Geometry", .product(name: "Dependencies", package: "swift-dependencies")]),
    .target(name: "Profiler"),
    .target(name: "Renamable"),
    .target(name: "Logging", dependencies: ["BaseHelpers"]),
    .target(name: "GlyphGrid", dependencies: ["BaseHelpers", "TextCore"]),
    .target(name: "Resizable", dependencies: ["BaseHelpers", "Geometry", "Shortcuts"]),
    .target(name: "Scrolling", dependencies: ["ScrollKit", .product(name: "SmoothGradient", package: "SmoothGradient")]),
    .target(name: "Selection", dependencies: ["BaseHelpers", "Geometry", "Scrolling"]),
    .target(name: "FocusHelper", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    ]),
    
    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "HoverAsync"),
    .target(name: "ImageCompression"),
    .target(name: "TouchInertia"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts", dependencies: ["BaseHelpers"]),
    
    /// Networking
    .target(name: "APIHandler", dependencies: [
      "BaseHelpers",
      .product(name: "KeychainSwift", package: "keychain-swift"),
      .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro")
    ]),
    .target(name: "Keychain", dependencies: [
      .product(name: "KeychainSwift", package: "keychain-swift"),
      .product(name: "Dependencies", package: "swift-dependencies")
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
