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
    .library(name: "BaseStyles", targets: ["BaseStyles"]),
    
    /// Utilities
    .library(name: "Utilities", targets: [
      "Geometry",
      "Profiler",
      "Renamable",
      "Logging",
      "Resizable",
      "GlyphGrid",
      "Scrolling",
      "Selection",
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
    /// Macros
    .library(
      name: "Macros",
      targets: ["Macros"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/dvclmn/TextCore", branch: "main"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.3"),
    .package(url: "https://github.com/danielsaidi/ScrollKit", from: "0.5.1"),
    .package(url: "https://github.com/raymondjavaxx/SmoothGradient", from: "1.0.0"),
    .package(url: "https://github.com/swiftlang/swift-syntax", from: "510.0.3"),
  ],
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("GrainOverlay/Assets.xcassets")]),
    
    /// Utilities
    .target(name: "Geometry", dependencies: [.product(name: "Dependencies", package: "swift-dependencies")]),
    .target(name: "Profiler"),
    .target(name: "Renamable"),
    .target(name: "Logging", dependencies: ["BaseHelpers"]),
    .target(name: "GlyphGrid", dependencies: ["BaseHelpers", "TextCore"]),
    .target(name: "Resizable", dependencies: ["BaseHelpers", "Geometry"]),
    .target(name: "Scrolling", dependencies: ["ScrollKit", .product(name: "SmoothGradient", package: "SmoothGradient")]),
    .target(name: "Selection", dependencies: ["BaseHelpers", "Geometry", "Scrolling"]),
    
    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "HoverAsync"),
    .target(name: "ImageCompression"),
    .target(name: "TouchInertia"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts"),
    
    /// Macros
    .target(name: "Macros", dependencies: ["MacroDefinitions"]),
    .macro(
      name: "MacroDefinitions",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
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
