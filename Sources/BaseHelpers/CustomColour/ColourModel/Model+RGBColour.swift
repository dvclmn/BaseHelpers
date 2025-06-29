//
//  Model+RGB.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct RGBColour: Identifiable, Equatable, Hashable, Sendable, Codable, ColourModel {
  public let id: UUID
  public var red: Double
  public var green: Double
  public var blue: Double
  public var alpha: Double

  public init(
    colour: Color,
    environment: EnvironmentValues,
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
    )
  }

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0,

  ) {
    self.id = UUID()
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }

  public init(
    r: Double,
    g: Double,
    b: Double,
    a: Double = 1.0,

  ) {
    self.init(red: r, green: g, blue: b, alpha: a)
  }

  public init(
    gray: Double,
    alpha: Double = 1.0,
  ) {
    self.init(red: gray, green: gray, blue: gray, alpha: alpha)
  }

  public init(
    resolved: Color.Resolved,
  ) {
    self.init(
      red: resolved.red.toDouble, green: resolved.green.toDouble, blue: resolved.blue.toDouble,
      alpha: resolved.opacity.toDouble)
  }

}

extension RGBColour {

  /// Calculates relative luminance using the standard formula
  public var luminance: Double {
    let result = 0.299 * red + 0.587 * green + 0.114 * blue
    return result.clamped(to: 0...1)
  }

  /// Create a color with specified brightness (0.0 to 1.0)
  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> RGBColour {
    return RGBColour(red: brightness, green: brightness, blue: brightness, alpha: alpha)
  }

  /// Create a semi-transparent version of this color
  public func withAlpha(_ alpha: Double) -> RGBColour {
    return RGBColour(red: red, green: green, blue: blue, alpha: alpha)
  }

  public mutating func opacity(_ opacity: Double) {
    self.alpha = opacity
    //    return RGBColour(red: red, green: green, blue: blue, alpha: alpha)
  }

  public func toHSV() -> HSBColour {
    let result = HSBColour(fromRGB: self)
    return result
  }

  //  public var swiftUIColour: Color {
  //    Color(
  //      colourSpace,
  //      red: red,
  //      green: green,
  //      blue: blue,
  //      opacity: alpha
  //    )
  //  }

  public func swiftUIColour(includesAlpha: Bool = true) -> Color {
    Color(
      colourSpace,
      red: red,
      green: green,
      blue: blue,
      opacity: includesAlpha ? alpha : 1.0
    )
  }

  public init(fromHSV hsv: HSBColour) {
    let h = hsv.hue
    let s = hsv.saturation
    let v = hsv.brightness

    let c = v * s
    let x = c * (1 - abs((h * 6).truncatingRemainder(dividingBy: 2) - 1))
    let m = v - c

    let (r1, g1, b1): (Double, Double, Double)

    switch h * 6 {
      case 0..<1:
        (r1, g1, b1) = (c, x, 0)
      case 1..<2:
        (r1, g1, b1) = (x, c, 0)
      case 2..<3:
        (r1, g1, b1) = (0, c, x)
      case 3..<4:
        (r1, g1, b1) = (0, x, c)
      case 4..<5:
        (r1, g1, b1) = (x, 0, c)
      case 5..<6:
        (r1, g1, b1) = (c, 0, x)
      default:
        (r1, g1, b1) = (0, 0, 0)  // hue out of range — you might want to clamp instead
    }

    self.init(
      red: r1 + m,
      green: g1 + m,
      blue: b1 + m,
      alpha: hsv.alpha
    )
  }

  // MARK: - Contrasting Border colour

  /*
   let brightColor = RGBColour(red: 0.8, green: 0.9, blue: 0.7, alpha: 1.0)
   let darkColor = RGBColour(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0)
  
   // Simple usage with defaults
   let brightBorder = brightColor.contrastingBorderColor()
   let darkBorder = darkColor.contrastingBorderColor()
  
   // Custom adjustments
   let customBorder = brightColor.contrastingBorderColor(
   saturationAdjustment: 0.3,
   brightnessAdjustment: 0.4,
   hueShift: 20
   )
  
   // Fine-tuned control
   let fineTunedBorder = brightColor.contrastingBorderColor(
   lightColorAdjustments: (saturation: 0.25, brightness: -0.35, hue: 12),
   darkColorAdjustments: (saturation: -0.1, brightness: 0.5, hue: -8)
   )
   */

  public func contrastingBorderColour(
    sat: Double,
    brightness: Double,
    hue: Double
      //    using adjustment: LuminanceAwareAdjustment
  ) -> RGBColour {
    let adjustment = LuminanceAwareAdjustment(symmetric: .init(h: hue, s: sat, b: brightness))
    let hsb = HSBColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    return RGBColour(fromHSV: hsb.applying(adjustment: adjustmentToApply))
  }

  public func contrastingBorderColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
    let hsb = HSBColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    return RGBColour(fromHSV: hsb.applying(adjustment: adjustmentToApply))
  }

  public func contrastingBorderColour(
    symmetricAdjustment: HSBAdjustmentStrength
  ) -> RGBColour {
    contrastingBorderColour(using: .init(symmetric: symmetricAdjustment))
  }

  public func contrastingBorderColour(
    light: HSBAdjustmentStrength,
    dark: HSBAdjustmentStrength
  ) -> RGBColour {
    contrastingBorderColour(using: .init(light: light, dark: dark))
  }

  /// Creates a contrasting border color based on the luminance of the current color
  /// - Parameters:
  ///   - saturationAdjustment: How much to adjust saturation (default: 0.2)
  ///   - brightnessAdjustment: How much to adjust brightness (default: 0.3)
  ///   - hueShift: How much to shift hue in degrees (default: 15°, can be negative)
  /// - Returns: A new RGBColour suitable for use as a contrasting border
  //  public func contrastingBorderColour(
  //    saturationAdjustment: Double = 0.2,
  //    /// Lower = less contrast against existing colour
  //    brightnessAdjustment: Double = 0.3,
  //    hueShift: Double = 15.0,
  //    luminanceTheshold: Double = 0.5
  //  ) -> RGBColour {
  //
  //    // Convert to HSB for easier manipulation
  //    let hsb = HSBColour(fromLinearRGB: self)
  //    let isBright = self.luminance > luminanceTheshold
  //
  //    // Calculate adjustments based on brightness
  //    let saturationDelta = isBright ? saturationAdjustment : -saturationAdjustment
  //    let brightnessDelta = isBright ? -brightnessAdjustment : brightnessAdjustment
  //    let hueShiftNormalized = (hueShift / 360.0) * (isBright ? 1 : -1)
  //
  //    // Apply adjustments with clamping
  //    let newSaturation = max(0, min(1, hsb.saturation + saturationDelta))
  //    let newBrightness = max(0, min(1, hsb.brightness + brightnessDelta))
  //
  //    // Handle hue wrapping (0-1 range)
  //    var newHue = hsb.hue + hueShiftNormalized
  //    if newHue < 0 { newHue += 1 }
  //    if newHue > 1 { newHue -= 1 }
  //
  //    let adjustedHSB = HSBColour(
  //      hue: newHue,
  //      saturation: newSaturation,
  //      brightness: newBrightness,
  //      alpha: hsb.alpha
  //    )
  //
  //    return RGBColour(fromHSV: adjustedHSB)
  //  }
  //
  //
  //  /// Creates a contrasting border color with separate parameters for light and dark colors
  //  public func contrastingBorderColour(
  //    lightColorAdjustments: (saturation: Double, brightness: Double, hue: Double) = (0.2, -0.3, 15),
  //    darkColorAdjustments: (saturation: Double, brightness: Double, hue: Double) = (-0.15, 0.4, -10)
  //  ) -> RGBColour {
  //
  //    let hsb = HSBColour(fromLinearRGB: self)
  //    let isBright = luminance > 0.5
  //
  //    let adjustments = isBright ? lightColorAdjustments : darkColorAdjustments
  //
  //    let newSaturation = max(0, min(1, hsb.saturation + adjustments.saturation))
  //    let newBrightness = max(0, min(1, hsb.brightness + adjustments.brightness))
  //
  //    var newHue = hsb.hue + (adjustments.hue / 360.0)
  //    if newHue < 0 { newHue += 1 }
  //    if newHue > 1 { newHue -= 1 }
  //
  //    let adjustedHSB = HSBColour(
  //      hue: newHue,
  //      saturation: newSaturation,
  //      brightness: newBrightness,
  //      alpha: hsb.alpha
  //    )
  //
  //    return RGBColour(fromHSV: adjustedHSB)
  //  }
}

public struct HSBAdjustmentStrength: Sendable {
  public var hue: Double  // Degrees
  public var saturation: Double
  public var brightness: Double

  public var luminanceTheshold: Double

  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
    luminanceTheshold: Double = 0.5
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.luminanceTheshold = luminanceTheshold
  }
  public init(
    h hue: Double,
    s saturation: Double,
    b brightness: Double,
    luminanceTheshold: Double = 0.5
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.luminanceTheshold = luminanceTheshold
  }
}
extension HSBAdjustmentStrength {
  /// Presets
//  public static let subtleLight = HSBAdjustmentStrength(
//    h: 10,
//    s: 0.1,
//    b: -0.2
//  )
//  public static let standardLight = HSBAdjustmentStrength(
//    h: 15,
//    s: 0.25,
//    b: -0.35
//  )
//  public static let highContrastLight = HSBAdjustmentStrength(
//    h: 17,
//    s: 0.4,
//    b: -0.7
//  )
//
//  public static let subtleDark = HSBAdjustmentStrength(
//    h: -6,
//    s: -0.03,
//    b: 0.08
//  )
//  public static let standardDark = HSBAdjustmentStrength(
//    h: -10,
//    s: 0.03,
//    b: 0.2
//  )
//  public static let highContrastDark = HSBAdjustmentStrength(
//    h: -12,
//    s: 0.05,
//    b: 0.38
//  )
}

public enum ContrastPreset {
  case subtle
  case moderate
  case standard
  case highContrast

  public var forDarkColours: HSBAdjustmentStrength {
    switch self {
      case .subtle:
        .init(
          h: -8,
          s: -0.01,
          b: 0.1
        )
      case .moderate:
        .init(
          h: -10,
          s: 0.02,
          b: 0.25
        )
      case .standard:
        .init(
          h: -14,
          s: 0.05,
          b: 0.45
        )
      case .highContrast:
        .init(
          h: -17,
          s: 0.08,
          b: 0.7
        )
    }
  }
  public var forLightColours: HSBAdjustmentStrength {

    switch self {
      case .subtle:
        .init(
          h: -8,
          s: 0.03,
          b: -0.18
        )
      case .moderate:
        .init(
          h: -10,
          s: 0.1,
          b: -0.35
        )
      case .standard:
        .init(
          h: -12,
          s: 0.15,
          b: -0.58
        )
      case .highContrast:
        .init(
          h: -14,
          s: 0.2,
          b: -0.7
        )

    }
  }
}

public struct LuminanceAwareAdjustment: Sendable {
  public var light: HSBAdjustmentStrength
  public var dark: HSBAdjustmentStrength
  public var luminanceTheshold: Double

  public init(
    light: HSBAdjustmentStrength,
    dark: HSBAdjustmentStrength,
    luminanceTheshold: Double = 0.5
  ) {
    self.light = light
    self.dark = dark
    self.luminanceTheshold = luminanceTheshold
  }

  /// Symmetric adjustment – auto-inverts for dark colours
  public init(symmetric adjustment: HSBAdjustmentStrength) {

    let luminance = adjustment.luminanceTheshold
    self.light = adjustment
    self.dark = HSBAdjustmentStrength(
      hue: -adjustment.hue,
      saturation: -adjustment.saturation,
      brightness: -adjustment.brightness,
      luminanceTheshold: luminance
    )
    self.luminanceTheshold = luminance
  }

  public func adjustment(forLuminance luminance: Double) -> HSBAdjustmentStrength {
    luminance > self.luminanceTheshold ? light : dark
  }
  
  public static func contrastPreset(_ preset: ContrastPreset) -> Self {
    return LuminanceAwareAdjustment(
      light: preset.forLightColours,
      dark: preset.forDarkColours
    )
  }
}
//extension LuminanceAwareAdjustment {
//  public static let subtle = LuminanceAwareAdjustment(
//    light: .subtleLight,
//    dark: .subtleDark
//  )
//  public static let standard = LuminanceAwareAdjustment(
//    light: .standardLight,
//    dark: .standardDark
//  )
//  public static let highContrast = LuminanceAwareAdjustment(
//    light: .highContrastLight,
//    dark: .highContrastDark
//  )
//}
