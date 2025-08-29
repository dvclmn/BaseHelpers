//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import NSUI
import SwiftUI

/// ```
/// struct ContentView: View {
///   let selectedColor: NamedColour = .indigo
///
///   var body: some View {
///     VStack {
///       Rectangle()
///         .fill(selectedColor.color)
///         .frame(width: 100, height: 100)
///       Text("Color: \(selectedColor.name)")
///     }
///   }
/// }
/// ```
public struct NamedColour: Sendable {
  public let colour: Color
  public let name: String

  
  //  public init(
  //    swatch: Swatch
  //  ) {
  //    switch swatch.primitiveColour {
  //      case .red:
  //        <#code#>
  //      case .orange:
  //        <#code#>
  //      case .yellow:
  //        <#code#>
  //      case .green:
  //        <#code#>
  //      case .blue:
  //        <#code#>
  //      case .purple:
  //        <#code#>
  //      case .pink:
  //        <#code#>
  //      case .brown:
  //        <#code#>
  //      case .grey:
  //        <#code#>
  //      case .black:
  //        <#code#>
  //      case .white:
  //        <#code#>
  //    }
  //  }

  public static let red = Color.red.namedColour
  public static let blue = Color.blue.namedColour
  public static let green = Color.green.namedColour
  public static let orange = Color.orange.namedColour
  public static let yellow = Color.yellow.namedColour
  public static let pink = Color.pink.namedColour
  public static let purple = Color.purple.namedColour
  public static let indigo = Color.indigo.namedColour
  public static let mint = Color.mint.namedColour
  public static let cyan = Color.cyan.namedColour
  public static let brown = Color.brown.namedColour
  public static let gray = Color.gray.namedColour
  public static let black = Color.black.namedColour
  public static let white = Color.white.namedColour
  public static let clear = Color.clear.namedColour
  public static let primary = Color.primary.namedColour
  public static let secondary = Color.secondary.namedColour
  public static let accentColor = Color.accentColor.namedColour
}

extension Color {

  public var namedColour: NamedColour? {
    switch self {
      case .red: NamedColour(colour: .red, name: "Red")
      case .blue: NamedColour(colour: .blue, name: "Blue")
      case .green: NamedColour(colour: .green, name: "Green")
      case .orange: NamedColour(colour: .orange, name: "Orange")
      case .yellow: NamedColour(colour: .yellow, name: "Yellow")
      case .pink: NamedColour(colour: .pink, name: "Pink")
      case .purple: NamedColour(colour: .purple, name: "Purple")
      case .indigo: NamedColour(colour: .indigo, name: "Indigo")
      case .mint: NamedColour(colour: .mint, name: "Mint")
      case .cyan: NamedColour(colour: .cyan, name: "Cyan")
      case .brown: NamedColour(colour: .brown, name: "Brown")
      case .gray: NamedColour(colour: .gray, name: "Gray")
      case .black: NamedColour(colour: .black, name: "Black")
      case .white: NamedColour(colour: .white, name: "White")
      case .clear: NamedColour(colour: .clear, name: "Clear")
      case .primary: NamedColour(colour: .primary, name: "Primary")
      case .secondary: NamedColour(colour: .secondary, name: "Secondary")
      case .accentColor: NamedColour(colour: .accentColor, name: "Accent")
      default: nil
    }
  }

  public func complementary(
    strength: Double = 1.0,
    environment: EnvironmentValues
  ) -> Color {

    let hsvColour = HSVColour(colour: self, environment: environment)
    let complementary = hsvColour.complementary(strength: strength)
    return complementary.swiftUIColor
  }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    environment: EnvironmentValues
  ) -> Color {

    let hsvColour = HSVColour(colour: self, environment: environment)
    let adjustment = HSVAdjustment.applyingModifiers(
      for: hsvColour,
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )

    let adjustedHSV = hsvColour.applying(adjustment: adjustment)

    return adjustedHSV.swiftUIColor
  }

  public var barelyThereOpacity: Color {
    self.opacity(0.03)
  }

  public var faintOpacity: Color {
    self.opacity(0.1)
  }
  public var lowOpacity: Color {
    self.opacity(0.3)
  }
  public var midOpacity: Color {
    self.opacity(0.6)
  }
  public var almostFullOpacity: Color {
    self.opacity(0.85)
  }

  public func mixCompatible(
    with rhs: Color,
    by fraction: Double,
    in colorSpace: Gradient.ColorSpace = .perceptual
  ) -> Color {
    guard #available(macOS 15, iOS 18, *) else {
      return self
    }
    return self.mix(
      with: rhs,
      by: fraction,
      in: colorSpace
    )
  }

  public var toShapeStyle: AnyShapeStyle {
    AnyShapeStyle(self)
  }
}

//#endif

extension Color {
  public static func random(randomOpacity: Bool = false) -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: randomOpacity ? .random(in: 0...1) : 1
    )
  }

  public var toNSColour: NSUIColor {
    NSUIColor(self)
  }

  /// Create a `Color` instance from a hex string in SwiftUI.
  /// Supports the following formats:

  /// 1. 3-digit hex (RGB)
  /// 2. 6-digit hex (RGB)
  /// 3. 8-digit hex (ARGB)
  ///
  /// 6-digit hex (RGB)
  /// `let redColor = Color(hex: "FE6057")`
  ///
  /// 3-digit hex (RGB)
  /// `let blueColor = Color(hex: "00F")`
  ///
  /// 8-digit hex (ARGB)
  /// `let transparentGreen = Color(hex: "8000FF00")`
  public init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0

    } else if length == 8 {
      r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x0000_00FF) / 255.0

    } else {
      return nil
    }

    self.init(red: r, green: g, blue: b, opacity: a)
  }

}

public struct TrafficLightsModifier: ViewModifier {

  public func body(content: Content) -> some View {
    content
      .overlay(alignment: .topLeading) {
        if isPreview {
          HStack {

            Circle()
              .fill(Color(hex: "FE6057") ?? Color.red)

            Circle()
              .fill(Color(hex: "FFBC2E") ?? Color.yellow)

            Circle()
              .fill(Color(hex: "28C840") ?? Color.green)

          }
          .frame(height: 12)
          .padding(20)
        }
      }
  }
}
extension View {
  public func trafficLightsPreview() -> some View {
    self.modifier(TrafficLightsModifier())
  }
}

extension Array where Element == Color {
  public static let rainbow: [Color] = [
    .red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .red,
  ]
}

// MARK: - Random colour
extension ShapeStyle where Self == Color {
  public static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
  public static var fadedBlack: Color {
    .black.opacity(0.2)
  }
  public static var fadedBlackDarker: Color {
    .black.opacity(0.4)
  }

}

/// This is cool and all, but there already exists a `NSColor.colorNameComponent` 🥲
//func namedColorDescription(_ color: NSColor) -> String? {
//  let namedColors: [(NSColor, String)] = [
//    (.systemBlue, "systemBlue"),
//    (.systemBrown, "systemBrown"),
//    (.systemGray, "systemGray"),
//    (.systemGreen, "systemGreen"),
//    (.systemIndigo, "systemIndigo"),
//    (.systemOrange, "systemOrange"),
//    (.systemPink, "systemPink"),
//    (.systemPurple, "systemPurple"),
//    (.systemRed, "systemRed"),
//    (.systemTeal, "systemTeal"),
//    (.systemYellow, "systemYellow"),
//    (.black, "black"),
//    (.blue, "blue"),
//    (.brown, "brown"),
//    (.clear, "clear"),
//    (.cyan, "cyan"),
//    (.darkGray, "darkGray"),
//    (.gray, "gray"),
//    (.green, "green"),
//    (.lightGray, "lightGray"),
//    (.magenta, "magenta"),
//    (.orange, "orange"),
//    (.purple, "purple"),
//    (.red, "red"),
//    (.white, "white"),
//    (.yellow, "yellow")
//  ]
//
//  for (namedColor, name) in namedColors {
//    if color.isClose(to: namedColor) {
//      return name
//    }
//  }
//
//  return nil
//}
//
//func colorDescription(_ color: NSColor) -> String {
//  if let name = namedColorDescription(color) {
//    return name
//  }
//
//  if let sRGBColor = color.usingColorSpace(.sRGB) {
//    let red = Int(sRGBColor.redComponent * 255)
//    let green = Int(sRGBColor.greenComponent * 255)
//    let blue = Int(sRGBColor.blueComponent * 255)
//    let alpha = Int(sRGBColor.alphaComponent * 100)
//    return "RGB(\(red), \(green), \(blue), \(alpha)%)"
//  } else {
//    return color.description
//  }
//}
//
//public extension NSColor {
//
//  var displayName: String {
//    colorDescription(self)
//  }
//
//  func isClose(to other: NSColor, tolerance: CGFloat = 0.01) -> Bool {
//    guard let rgb1 = self.usingColorSpace(.sRGB),
//          let rgb2 = other.usingColorSpace(.sRGB) else {
//      return false
//    }
//
//    let redDiff = abs(rgb1.redComponent - rgb2.redComponent)
//    let greenDiff = abs(rgb1.greenComponent - rgb2.greenComponent)
//    let blueDiff = abs(rgb1.blueComponent - rgb2.blueComponent)
//    let alphaDiff = abs(rgb1.alphaComponent - rgb2.alphaComponent)
//
//    return redDiff <= tolerance && greenDiff <= tolerance && blueDiff <= tolerance && alphaDiff <= tolerance
//  }
//}
