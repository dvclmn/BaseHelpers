// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "Helpers",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0")
  ],
  products: [
    .library(
      name: "Helpers",
      targets: [
        "BaseHelpers",
        "HoverAsync",
        "ImageCompression",
        "Shaders",
        "Shortcuts",
      ]
    )
  ],
  targets: [
    .target(name: "BaseHelpers"),
    .target(name: "HoverAsync"),
    .target(name: "ImageCompression"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts"),
    
  ]
)
