// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let localPackagesRoot = "/Users/dvclmn/Apps/_ Swift Packages"

let package = Package(
  name: "Utilities",
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
      "Scrolling",
      "Selection",
    ]),
  ],
  dependencies: [
    .package(name: "Helpers", path: "\(localPackagesRoot)/SwiftCollection/Helpers"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.3"),
    .package(url: "https://github.com/danielsaidi/ScrollKit.git", from: "0.5.1"),
    .package(url: "https://github.com/raymondjavaxx/SmoothGradient.git", from: "1.0.0"),
  ],
  targets: [
    .target(name: "Geometry", dependencies: [.product(name: "Dependencies", package: "swift-dependencies")]),
    .target(name: "Profiler"),
    .target(name: "Renamable"),
    .target(name: "Logging", dependencies: ["Helpers"]),
    .target(name: "Resizable", dependencies: ["Helpers", "Geometry"]),
    .target(name: "Scrolling", dependencies: ["ScrollKit", .product(name: "SmoothGradient", package: "SmoothGradient")]),
    .target(name: "Selection", dependencies: ["Helpers", "Geometry", "Scrolling"]),
  ]
)


