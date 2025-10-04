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
    .library(
      name: "BaseMacros",
      targets: [
        "CaseDetection",
        "MetaEnum",
        "Persistable",
        "SetOfOptions",
      ]
    ),
    //    .executable(
    //      name: "BaseMacrosClient",
    //      targets: ["BaseMacrosClient"]
    //    ),
    .library(name: "BaseNetworking", targets: ["BaseNetworking"]),

    /// Forwards / re-exports `BaseHelpers`, `BaseMacros` and `BaseComponents`,
    /// allowing writing `import BaseTools` to import all three at once
    .library(name: "BaseTools", targets: ["BaseTools"]),

    .library(name: "ColourExtract", targets: ["ColourExtract"]),
    .library(name: "CurveFunctions", targets: ["CurveFunctions"]),
    .library(name: "GridCanvas", targets: ["GridCanvas"]),
    .library(name: "LilyPad", targets: ["LilyPad"]),

    /// Common resources shared between `BaseHelpers` and `BaseMacros`
    .library(name: "SharedHelpers", targets: ["SharedHelpers"]),
    .library(name: "Wrecktangle", targets: ["Wrecktangle"]),
  ],

  // MARK: - Dependancies
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
    .package(url: "https://github.com/mattmassicotte/nsui", from: "1.3.0"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
  ],

  targets: [
    // MARK: - BaseMacro targets
    .macro(
      name: "BaseMacros",
      dependencies: [
        .product(name: "SharedHelpers", package: "SharedHelpers"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .target(name: "CaseDetection", dependencies: ["UtilityMacros"]),
    .target(name: "MetaEnum", dependencies: ["UtilityMacros"]),
    .target(name: "Persistable", dependencies: ["UtilityMacros"]),
    .target(name: "SetOfOptions", dependencies: ["UtilityMacros"]),

    .executableTarget(
      name: "BaseMacrosClient",
      dependencies: [
        "CaseDetection",
        "MetaEnum",
        "Persistable",
        "SetOfOptions",
      ]),

    // MARK: - Other targets
    .target(
      name: "BaseHelpers",
      dependencies: [
        "CurveFunctions",
        "SharedHelpers",
        "BaseMacros",
        .product(name: "NSUI", package: "nsui"),
      ],
      resources: [.process("Assets.xcassets")],
    ),
    .target(
      name: "BaseNetworking",
      dependencies: [
        "BaseHelpers",
        .product(name: "KeychainSwift", package: "keychain-swift"),
      ],
    ),
    .target(
      name: "BaseTools",
      dependencies: [
        .product(name: "BaseComponents", package: "BaseComponents"),
        "BaseHelpers",
        "SharedHelpers",
        "BaseMacros",
      ]
    ),
    .target(name: "ColourExtract", dependencies: []),
    .target(name: "CurveFunctions", dependencies: []),
    .target(name: "GridCanvas", dependencies: ["BaseHelpers"]),
    .target(name: "LilyPad", dependencies: ["BaseHelpers"]),
    .target(name: "SharedHelpers", dependencies: []),
    .target(name: "Wrecktangle", dependencies: []),

  ],
)
// MARK: - Convenient type-safe extensions
extension Target.Dependency {
  static var baseHelpers: Self { "BaseHelpers" }
  static var sharedHelpers: Self { "SharedHelpers" }
  static var baseMacros: Self { "BaseMacros" }
  
}
