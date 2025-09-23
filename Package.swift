// swift-tools-version: 6.1

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "BaseHelpers",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    .library(name: "BaseHelpers", targets: ["BaseHelpers"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "ColourExtract", targets: ["ColourExtract"]),
  ],
  
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/mattmassicotte/nsui", from: "1.3.0"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.1"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
  ],
  
  targets: [
    
    .target(
      name: "BaseHelpers",
      dependencies: [
        .product(name: "NSUI", package: "nsui"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
      ],
      resources: [.process("Assets.xcassets")],
    ),
    
    .target(
      name: "Networking",
      dependencies: [
        "BaseHelpers",
        .product(name: "KeychainSwift", package: "keychain-swift"),
      ],
    ),
    
      .target(
        name: "ColourExtract",
        dependencies: [
          "BaseHelpers",
          .product(name: "KeychainSwift", package: "keychain-swift"),
        ],
      ),
  ],
)
