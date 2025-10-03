// swift-tools-version: 6.1

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "BaseHelpers",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0"),
  ],
  products: [
    .library(name: "BaseHelpers", targets: ["BaseHelpers"]),
    
    /// This could afford to be handled or named better — this exists
    /// because I'm trying to avoid a circular dependancy between
    /// BaseMacros and BaseHelpers
//    .library(name: "PrimitiveHelpers", targets: ["PrimitiveHelpers"]),
    
    .library(name: "ColourExtract", targets: ["ColourExtract"]),
    .library(name: "CurveFunctions", targets: ["CurveFunctions"]),
    .library(name: "GridCanvas", targets: ["GridCanvas"]),
    .library(name: "BaseNetworking", targets: ["BaseNetworking"]),
  ],

  dependencies: [
    .package(url: "https://github.com/dvclmn/BaseMacros", branch: "main"),
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/mattmassicotte/nsui", from: "1.3.0"),
//    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.1"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
  ],

  targets: [

    .target(
      name: "BaseHelpers",
      dependencies: [
        "CurveFunctions",
        "PrimitiveHelpers",
        .product(name: "NSUI", package: "nsui"),
        .product(name: "BaseMacros", package: "BaseMacros"),
      ],
      resources: [.process("Assets.xcassets")],
    ),
    .target(name: "ColourExtract", dependencies: []),
    .target(name: "CurveFunctions", dependencies: []),
    .target(name: "GridCanvas", dependencies: ["BaseHelpers"]),

    .target(
      name: "BaseNetworking",
      dependencies: [
        "BaseHelpers",
        .product(name: "KeychainSwift", package: "keychain-swift"),
      ],
    ),

  ],
)
