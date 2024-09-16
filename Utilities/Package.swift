// swift-tools-version: 5.10

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "Helpers",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    
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
    
      .library(name: "BaseStyles", targets: ["BaseStyles"]),
    
    .library(
      name: "Helpers",
      targets: [
        "BaseHelpers",
        "HoverAsync",
        "ImageCompression",
        "Shaders",
        "TouchInertia",
        "Shortcuts",
      ]
    ),
    .library(
      name: "Macros",
      targets: ["Macros"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/dvclmn/TextCore.git", branch: "main"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.3"),
    .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
    .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
    .package(url: "https://github.com/swiftlang/swift-syntax", from: "510.0.3"),
  ],
  targets: [
    .target(name: "BaseStyles", resources: [.copy("Assets.xcassets")]),
    .target(name: "Geometry", dependencies: [.product(name: "Dependencies", package: "swift-dependencies")]),
    .target(name: "Profiler"),
    .target(name: "Renamable"),
    .target(name: "Logging", dependencies: ["Helpers"]),
    .target(name: "GlyphGrid", dependencies: ["Helpers", "TextCore"]),
    .target(name: "Resizable", dependencies: ["Helpers", "Geometry"]),
    .target(name: "Scrolling", dependencies: ["ScrollKit", .product(name: "SmoothGradient", package: "SmoothGradient")]),
    .target(name: "Selection", dependencies: ["Helpers", "Geometry", "Scrolling"]),
    
///
      .target(name: "BaseHelpers"),
      .target(name: "HoverAsync"),
      .target(name: "ImageCompression"),
      .target(name: "TouchInertia"),
      .target(name: "Shaders"),
      .target(name: "Shortcuts"),
    
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
