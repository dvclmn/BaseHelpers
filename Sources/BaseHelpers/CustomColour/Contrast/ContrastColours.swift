//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

extension RGBColour {

  public func contrastColour(
    sat: Double,
    brightness: Double,
    hue: Double
  ) -> RGBColour {
    
    let hsvAdjustment = HSVAdjustment(h: hue, s: sat, b: brightness)
    let lumaAwareAdjustment = LuminanceAwareAdjustment(
      symmetric: hsvAdjustment
    )
    return self.contrastColour(using: lumaAwareAdjustment)
//    let hsvColour = HSVColour(fromRGB: self)
//    let adjustmentToApply = lumaAwareAdjustment.adjustment(forLuminance: luminance)
//    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
//    return RGBColour(fromHSV: newHSV)
  }

  public func contrastColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
//    let hsv = HSVColour(fromRGB: self)
//    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
//    return RGBColour(fromHSV: hsv.applying(adjustment: adjustmentToApply))
    
//    let hsvAdjustment = HSVAdjustment(h: hue, s: sat, b: brightness)
//    let lumaAwareAdjustment = LuminanceAwareAdjustment(
//      symmetric: hsvAdjustment
//    )
    let hsvColour = HSVColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: luminance)
    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
    return RGBColour(fromHSV: newHSV)
    
  }

  public func contrastColour(
    symmetricAdjustment: HSVAdjustment
  ) -> RGBColour {
    contrastColour(using: .init(symmetric: symmetricAdjustment))
  }

  public func contrastColour(
    light: HSVAdjustment,
    dark: HSVAdjustment
  ) -> RGBColour {
    contrastColour(using: .init(light: light, dark: dark))
  }
}

public enum ContrastPreset {
  case subtle
  case moderate
  case standard
  case highContrast

  public var forDarkColours: HSVAdjustment {
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
  public var forLightColours: HSVAdjustment {

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
