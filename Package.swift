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
    .library(
      name: "BaseHelpers",
      targets: ["BaseHelpers"]
    ),
  ],
  
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/mattmassicotte/nsui", from: "1.3.0"),
    .package(url: "https://github.com/ukushu/Ifrit", from: "3.0.0"),
    /// Important: Hoping to keep BaseHelpers as light on dependancies as possible.
    /// Especially my own Swift Packages
//    .package(url: "https://github.com/dvclmn/BaseStyles", branch: "main"),
  ],
  
  targets: [
    .target(
      name: "BaseHelpers",
      dependencies: [
//        .product(name: "BaseStyles", package: "BaseStyles"),
        .product(name: "NSUI", package: "nsui"),
        .product(name: "IfritStatic", package: "Ifrit"),
      ],
      resources: [.copy("Assets/Assets.xcassets")],
    ),
  ],
)
