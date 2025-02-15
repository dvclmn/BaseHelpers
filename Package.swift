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

    /// Helpers
    .library(
      name: "BaseHelpers",
      targets: [
        "BaseHelpers",
        "Shaders",
      ]
    ),
  ],
  dependencies: [],
  
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("Assets.xcassets")]),
    .target(name: "Grainient", dependencies: ["BaseStyles"]),

    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "Shaders"),
    
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
