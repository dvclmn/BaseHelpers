// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "BasePrimitives",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    .library(name: "BasePrimitives", targets: ["BasePrimitives"])
  ],
//  dependencies: [],
  targets: [
    .target(
      name: "BasePrimitives",
//      dependencies: []
    )
  ]
)
