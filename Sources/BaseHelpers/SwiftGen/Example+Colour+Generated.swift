// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset: Sendable {
  public enum Swatch {
    public static let asciiBlack = ColorAsset(name: "swatch/asciiBlack")
    public static let asciiBlue = ColorAsset(name: "swatch/asciiBlue")
    public static let asciiBrown = ColorAsset(name: "swatch/asciiBrown")
    public static let asciiGreen = ColorAsset(name: "swatch/asciiGreen")
    public static let asciiGrey = ColorAsset(name: "swatch/asciiGrey")
    public static let asciiMaroon = ColorAsset(name: "swatch/asciiMaroon")
    public static let asciiPurple = ColorAsset(name: "swatch/asciiPurple")
    public static let asciiRed = ColorAsset(name: "swatch/asciiRed")
    public static let asciiTeal = ColorAsset(name: "swatch/asciiTeal")
    public static let asciiTealDull = ColorAsset(name: "swatch/asciiTealDull")
    public static let asciiWarmWhite = ColorAsset(name: "swatch/asciiWarmWhite")
    public static let asciiWhite = ColorAsset(name: "swatch/asciiWhite")
    public static let asciiYellow = ColorAsset(name: "swatch/asciiYellow")
    public static let blackTrue = ColorAsset(name: "swatch/blackTrue")
    public static let blue10 = ColorAsset(name: "swatch/blue10")
    public static let blue20 = ColorAsset(name: "swatch/blue20")
    public static let blue30 = ColorAsset(name: "swatch/blue30")
    public static let blue40 = ColorAsset(name: "swatch/blue40")
    public static let blue50 = ColorAsset(name: "swatch/blue50")
    public static let blue60 = ColorAsset(name: "swatch/blue60")
    public static let brown30 = ColorAsset(name: "swatch/brown30")
    public static let brown40 = ColorAsset(name: "swatch/brown40")
    public static let brown50 = ColorAsset(name: "swatch/brown50")
    public static let brown60 = ColorAsset(name: "swatch/brown60")
    public static let green20 = ColorAsset(name: "swatch/green20")
    public static let green30V = ColorAsset(name: "swatch/green30V")
    public static let green50 = ColorAsset(name: "swatch/green50")
    public static let green70 = ColorAsset(name: "swatch/green70")
    public static let grey05 = ColorAsset(name: "swatch/grey05")
    public static let grey10 = ColorAsset(name: "swatch/grey10")
    public static let grey20 = ColorAsset(name: "swatch/grey20")
    public static let grey30 = ColorAsset(name: "swatch/grey30")
    public static let grey40 = ColorAsset(name: "swatch/grey40")
    public static let grey80 = ColorAsset(name: "swatch/grey80")
    public static let grey90 = ColorAsset(name: "swatch/grey90")
    public static let lime30 = ColorAsset(name: "swatch/lime30")
    public static let lime40 = ColorAsset(name: "swatch/lime40")
    public static let neonGreen = ColorAsset(name: "swatch/neonGreen")
    public static let neonOrange = ColorAsset(name: "swatch/neonOrange")
    public static let neonPink = ColorAsset(name: "swatch/neonPink")
    public static let neonYellow = ColorAsset(name: "swatch/neonYellow")
    public static let olive40 = ColorAsset(name: "swatch/olive40")
    public static let olive70 = ColorAsset(name: "swatch/olive70")
    public static let orange30 = ColorAsset(name: "swatch/orange30")
    public static let peach20 = ColorAsset(name: "swatch/peach20")
    public static let peach30 = ColorAsset(name: "swatch/peach30")
    public static let peach30V = ColorAsset(name: "swatch/peach30V")
    public static let peach40 = ColorAsset(name: "swatch/peach40")
    public static let plum30 = ColorAsset(name: "swatch/plum30")
    public static let plum40 = ColorAsset(name: "swatch/plum40")
    public static let plum50 = ColorAsset(name: "swatch/plum50")
    public static let plum60 = ColorAsset(name: "swatch/plum60")
    public static let plum70 = ColorAsset(name: "swatch/plum70")
    public static let plum80 = ColorAsset(name: "swatch/plum80")
    public static let plum90 = ColorAsset(name: "swatch/plum90")
    public static let purple20 = ColorAsset(name: "swatch/purple20")
    public static let purple30 = ColorAsset(name: "swatch/purple30")
    public static let purple40 = ColorAsset(name: "swatch/purple40")
    public static let purple50 = ColorAsset(name: "swatch/purple50")
    public static let purple70 = ColorAsset(name: "swatch/purple70")
    public static let red50 = ColorAsset(name: "swatch/red50")
    public static let red50V = ColorAsset(name: "swatch/red50V")
    public static let slate30 = ColorAsset(name: "swatch/slate30")
    public static let slate40 = ColorAsset(name: "swatch/slate40")
    public static let slate50 = ColorAsset(name: "swatch/slate50")
    public static let slate60 = ColorAsset(name: "swatch/slate60")
    public static let slate70 = ColorAsset(name: "swatch/slate70")
    public static let slate80 = ColorAsset(name: "swatch/slate80")
    public static let slate90 = ColorAsset(name: "swatch/slate90")
    public static let teal30 = ColorAsset(name: "swatch/teal30")
    public static let teal50 = ColorAsset(name: "swatch/teal50")
    public static let whiteBone = ColorAsset(name: "swatch/whiteBone")
    public static let whiteOff = ColorAsset(name: "swatch/whiteOff")
    public static let whiteTrue = ColorAsset(name: "swatch/whiteTrue")
    public static let yellow30 = ColorAsset(name: "swatch/yellow30")
    public static let yellow40 = ColorAsset(name: "swatch/yellow40")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
