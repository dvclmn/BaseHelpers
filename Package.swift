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
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/mattmassicotte/nsui", from: "1.3.0"),
    .package(url: "https://github.com/ukushu/Ifrit", from: "3.0.0"),
  ],
  
  targets: [
    .target(
      name: "BaseHelpers",
      dependencies: [
        .product(name: "NSUI", package: "nsui"),
        .product(name: "IfritStatic", package: "Ifrit"),
      ],
      swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")],
    ),
  ],
//  swiftLanguageModes: [.v5]
)

//#if swift(>=5.6)
//package.dependencies += [
//  .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
//]
//#endif
