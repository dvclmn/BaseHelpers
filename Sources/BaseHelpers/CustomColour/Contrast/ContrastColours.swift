//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

extension RGBColour {

  // MARK: - Main Contrast method
  public func contrastColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
    let hsvColour = HSVColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: luminance)
    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
    return RGBColour(fromHSV: newHSV)
  }

  // MARK: - Convenient Overloads
  
  public func contrastColour(withPreset preset: ContrastPreset) -> RGBColour {
    let lumaAwareAdjustment = LuminanceAwareAdjustment.contrastPreset(preset)
    return self.contrastColour(using: lumaAwareAdjustment)
  }
  
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
  }

  public func contrastColour(
    symmetricAdjustment: HSVAdjustment
  ) -> RGBColour {
    let adjustment = LuminanceAwareAdjustment(symmetric: symmetricAdjustment)
    return self.contrastColour(using: adjustment)
  }

  public func contrastColour(
    light: HSVAdjustment,
    dark: HSVAdjustment
  ) -> RGBColour {
    let adjustment = LuminanceAwareAdjustment(light: light, dark: dark)
    return self.contrastColour(using: adjustment)
  }
}

//public struct ContrastLevel {
//  /// Scalar from 0 (no change) to 1 (maximum contrast)
//  public var amount: Double
//  
//  public init(amount: Double) {
//    self.amount = amount.clamped(to: 0...1)
//  }
//  
//  private static let maxDarkAdjustment = HSVAdjustment(h: -17, s: 0.08, b: 0.7)
//  private static let maxLightAdjustment = HSVAdjustment(h: -14, s: 0.2, b: -0.7)
//  
////  public var forDarkColours: HSVAdjustment {
////    .zero.interpolated(to: Self.maxDarkAdjustment, amount: amount)
////  }
//  
////  public var forLightColours: HSVAdjustment {
////    .zero.interpolated(to: Self.maxLightAdjustment, amount: amount)
////  }
//}

public enum ContrastPreset: String, CaseIterable, Identifiable {
  case subtle
  case moderate
  case standard
  case highContrast
  
  public var id: String { rawValue }
  
  public var name: String {
    switch self {
      case .subtle: "Subtle"
      case .moderate: "Moderate"
      case .standard: "Standard"
      case .highContrast: "High Contrast"
    }
  }
  
  public func level(isMonochrome: Bool) -> ContrastLevel {
    switch self {
      case .subtle: ContrastLevel(amount: 0.2, isMonochrome: isMonochrome)
      case .moderate: ContrastLevel(amount: 0.4, isMonochrome: isMonochrome)
      case .standard: ContrastLevel(amount: 0.7, isMonochrome: isMonochrome)
      case .highContrast: ContrastLevel(amount: 1.0, isMonochrome: isMonochrome)
    }
  }
  

//  public var forDarkColours: HSVAdjustment {
//    switch self {
//      case .subtle:
//        .init(
//          h: -8,
//          s: -0.01,
//          b: 0.1
//        )
//      case .moderate:
//        .init(
//          h: -10,
//          s: 0.02,
//          b: 0.25
//        )
//      case .standard:
//        .init(
//          h: -14,
//          s: 0.05,
//          b: 0.45
//        )
//      case .highContrast:
//        .init(
//          h: -17,
//          s: 0.08,
//          b: 0.7
//        )
//    }
//  }
//  public var forLightColours: HSVAdjustment {
//
//    switch self {
//      case .subtle:
//        .init(
//          h: -8,
//          s: 0.03,
//          b: -0.18
//        )
//      case .moderate:
//        .init(
//          h: -10,
//          s: 0.1,
//          b: -0.35
//        )
//      case .standard:
//        .init(
//          h: -12,
//          s: 0.15,
//          b: -0.58
//        )
//      case .highContrast:
//        .init(
//          h: -14,
//          s: 0.2,
//          b: -0.7
//        )
//
//    }
//  }
}
