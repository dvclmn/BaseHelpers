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
//        "Shortcuts",
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
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
  ],
  
  targets: [
    /// Styles
    .target(name: "BaseStyles", resources: [.copy("GrainOverlay/Assets.xcassets")]),
    .target(name: "Grainient", dependencies: ["BaseStyles"]),

    /// Helpers
    .target(name: "BaseHelpers"),
    .target(name: "Shaders"),
//    .target(name: "Shortcuts", dependencies: ["BaseHelpers"]),
    
    /// Networking
    .target(name: "APIHandler", dependencies: [
      "BaseHelpers",
      .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
      .product(name: "KeychainSwift", package: "keychain-swift"),
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
