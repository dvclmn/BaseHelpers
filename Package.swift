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
      name: "BaseMacrosPackage",
      targets: [
        "AssociatedValues",
        "CaseDetection",
        "MetaEnum",
        "Persistable",
        "SetOfOptions",
      ]
    ),
    .executable(
      name: "BaseMacrosClient",
      targets: ["BaseMacrosClient"]
    ),
    .library(name: "BaseNetworking", targets: ["BaseNetworking"]),
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
        .sharedHelpers,
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ],
      path: "BaseMacros/MacroExpansions",
    ),
    .target(name: "AssociatedValues", dependencies: ["BaseMacros"], path: "BaseMacros/MacroDeclarations/AssociatedValues"),
    .target(name: "CaseDetection", dependencies: ["BaseMacros"], path: "BaseMacros/MacroDeclarations/AssociatedValues"),
    .target(name: "MetaEnum", dependencies: ["BaseMacros"], path: "BaseMacros/MacroDeclarations/AssociatedValues"),
    .target(name: "Persistable", dependencies: ["BaseMacros"], path: "BaseMacros/MacroDeclarations/AssociatedValues"),
    .target(name: "SetOfOptions", dependencies: ["BaseMacros"], path: "BaseMacros/MacroDeclarations/AssociatedValues"),

    .executableTarget(
      name: "BaseMacrosClient",
      dependencies: [
        "AssociatedValues",
        "CaseDetection",
        "MetaEnum",
        "Persistable",
        "SetOfOptions",
      ],
      path: "BaseMacros/BaseMacrosClient",
    ),

    // MARK: - Other targets
    .target(
      name: "BaseHelpers",
      dependencies: [
        .sharedHelpers,
        .baseMacros,
        "CurveFunctions",
        .product(name: "NSUI", package: "nsui"),
      ],
      resources: [.process("Assets.xcassets")],
    ),
    .target(
      name: "BaseNetworking",
      dependencies: [
        .baseHelpers,
        .product(name: "KeychainSwift", package: "keychain-swift"),
      ],
    ),
    .target(name: "ColourExtract"),
    .target(name: "CurveFunctions"),
    .target(name: "GridCanvas", dependencies: [.baseHelpers]),
    .target(name: "LilyPad", dependencies: [.baseHelpers]),
    .target(name: "SharedHelpers"),
    .target(name: "Wrecktangle"),

  ],
)
// MARK: - Convenient type-safe extensions
extension Target.Dependency {
  static var baseHelpers: Self { "BaseHelpers" }
  static var sharedHelpers: Self { "SharedHelpers" }
  static var baseMacros: Self { "BaseMacros" }
}
