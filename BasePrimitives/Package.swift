// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "BaseTools",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    .library(name: "BaseTools", targets: ["BaseTools"])
  ],
  dependencies: [
    .package(url: "https://github.com/dvclmn/BaseComponents", branch: "main"),
    .package(url: "https://github.com/dvclmn/BaseHelpers", branch: "main"),
  ],
  targets: [
    .target(
      name: "BaseTools",
      dependencies: [
        .product(name: "BaseComponents", package: "BaseComponents"),
        .product(name: "BaseHelpers", package: "BaseHelpers"),
      ]
    )
  ]
)
