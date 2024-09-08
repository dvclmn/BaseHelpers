// swift-tools-version:5.6

import PackageDescription

/// I think of the code in this package as foundational, not requiring other
/// third-party packages, 'could almost be part of base Swift' etc.
///
/// Code that relies more on other packages, is better suited for the
/// `Utilities` package.
///
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
        "TouchInertia",
        "Shortcuts",
      ]
    )
  ],
  targets: [
    .target(name: "BaseHelpers"),
    .target(name: "HoverAsync"),
    .target(name: "ImageCompression"),
    .target(name: "TouchInertia"),
    .target(name: "Shaders"),
    .target(name: "Shortcuts"),
    
  ]
)
