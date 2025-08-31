//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import NSUI
import SwiftUI

/// The goal here is to unify some common colour-related types,
/// namely SwiftUI's `Color`, my `RGBColour`,
/// `NamedColour` and `Swatch`.
public protocol ColourConvertible: Sendable {
  var swiftUIColour: Color { get }
  func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma,
    environment: EnvironmentValues?
  ) -> Color?
}

extension Color: ColourConvertible {
  public var swiftUIColour: Color { self }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    environment: EnvironmentValues? = nil
  ) -> Color? {

    guard let environment else { return nil }

    return self.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment
    ).swiftUIColour
  }
}

extension Double {
  public static let barelyThereOpacity: Self = 0.03
  public static let faintOpacity: Self = 0.1
  public static let lowOpacity: Self = 0.3
  public static let midOpacity: Self = 0.6
  public static let nearOpaque: Self = 0.85
}

extension Color {

  public var namedColour: NamedColour? {
    return NamedColour.allCases.first { $0.colour.swiftUIColour == self }
  }

  public func complementary(
    strength: Double = 1.0,
    environment: EnvironmentValues
  ) -> Color {

    let hsvColour = HSVColour(colour: self, environment: environment)
    let complementary = hsvColour.complementary(strength: strength)
    return complementary.swiftUIColour
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

    return adjustedHSV.swiftUIColour
  }

  public var barelyThereOpacity: Color { opacity(.barelyThereOpacity) }
  public var faintOpacity: Color { opacity(.faintOpacity) }
  public var lowOpacity: Color { opacity(.lowOpacity) }
  public var midOpacity: Color { opacity(.midOpacity) }
  public var nearOpaque: Color { opacity(.nearOpaque) }

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

  public var toShapeStyle: AnyShapeStyle { AnyShapeStyle(self) }
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

  public var toNSColour: NSUIColor { NSUIColor(self) }

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
