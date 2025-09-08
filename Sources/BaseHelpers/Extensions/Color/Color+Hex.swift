//
//  Color+Hex.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

public protocol RGBAConvertible {
  init(r: Double, g: Double, b: Double, a: Double)
}

extension Color: RGBAConvertible {
  public init(r: Double, g: Double, b: Double, a: Double) {
    self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
  }
}

extension RGBColour: RGBAConvertible {
  public init(r: Double, g: Double, b: Double, a: Double) {
    self.init(r: r, g: g, b: b, a: a, name: nil)
  }
}

extension RGBAConvertible {

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

    /// Clean up the hex string (removing `#` if present etc)
    let hexSanitized = hex.toSanitisedHex

    var rgb: UInt64 = 0

    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat

    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      a = 1.0  // Set to default of 1.0 for RGB

    } else if length == 8 {
      r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x0000_00FF) / 255.0

    } else {
      return nil
    }
    self.init(r: r, g: g, b: b, a: a)
    //    self.init(red: r, green: g, blue: b, opacity: a)
  }
}

extension String {

  /// Removes `#` or whitespace if present etc
  public var toSanitisedHex: String {
    var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    return hexSanitized
  }

  //  public var toRGBA: (CGFloat, CGFloat, CGFloat, CGFloat)? {
  //    /// RGBA must be 8 characters long
  //    guard self.count == 8 else { return nil }
  //    var rgb: UInt64 = 0
  //    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
  //
  //    let red = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
  //    let green = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
  //    let blue = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
  //    let alpha = CGFloat(rgb & 0x0000_00FF) / 255.0
  //
  //    return (red, green, blue, alpha)
  //  }
  //
  //  public var toRGB: (CGFloat, CGFloat, CGFloat)? {
  //    /// RGBA must be 6 characters long
  //    guard self.count == 6 else { return nil }
  //    var rgb: UInt64 = 0
  //    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
  //
  //    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
  //    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
  //    let blue = CGFloat(rgb & 0x0000FF) / 255.0
  //
  //    return (red, green, blue)
  //  }
}
