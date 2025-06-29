//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public struct LuminanceAwareAdjustment: Sendable {
  public var light: HSBAdjustment
  public var dark: HSBAdjustment
  
  /// What luminance value is considered dark vs light
  public var luminanceTheshold: Double
  
  /// Provide *two* adjustments; one for use with Light contexts, one for Dark
  public init(
    light: HSBAdjustment,
    dark: HSBAdjustment,
    luminanceTheshold: Double = 0.5
  ) {
    self.light = light
    self.dark = dark
    self.luminanceTheshold = luminanceTheshold
  }
  
  /// Provide a *single* adjustment, which auto-inverts for Dark colours
  public init(
    symmetric adjustment: HSBAdjustment,
    luminanceTheshold: Double = 0.5
  ) {
    
    self.light = adjustment
    self.dark = HSBAdjustment(
      hue: -adjustment.hue,
      saturation: -adjustment.saturation,
      brightness: -adjustment.brightness,
    )
    self.luminanceTheshold = luminanceTheshold
  }
  
  public func adjustment(forLuminance luminance: Double) -> HSBAdjustment {
    luminance > self.luminanceTheshold ? light : dark
  }
  
  public static func contrastPreset(_ preset: ContrastPreset) -> Self {
    return LuminanceAwareAdjustment(
      light: preset.forLightColours,
      dark: preset.forDarkColours
    )
  }
}

// MARK: - Contrasting Border colour

extension RGBColour {

  public func contrastColour(
    sat: Double,
    brightness: Double,
    hue: Double
  ) -> RGBColour {
    let adjustment = LuminanceAwareAdjustment(symmetric: .init(h: hue, s: sat, b: brightness))
    let hsb = HSBColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    return RGBColour(fromHSV: hsb.applying(adjustment: adjustmentToApply))
  }

  public func contrastColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
    let hsb = HSBColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    return RGBColour(fromHSV: hsb.applying(adjustment: adjustmentToApply))
  }

  public func contrastColour(
    symmetricAdjustment: HSBAdjustment
  ) -> RGBColour {
    contrastColour(using: .init(symmetric: symmetricAdjustment))
  }

  public func contrastColour(
    light: HSBAdjustment,
    dark: HSBAdjustment
  ) -> RGBColour {
    contrastColour(using: .init(light: light, dark: dark))
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



public enum ContrastPreset {
  case subtle
  case moderate
  case standard
  case highContrast

  public var forDarkColours: HSBAdjustment {
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
  public var forLightColours: HSBAdjustment {

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
