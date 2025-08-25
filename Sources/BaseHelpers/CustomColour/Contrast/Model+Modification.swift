//
//  Model+LumaLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import SwiftUI

extension EnvironmentValues {
  @Entry public var colourModification: ColourModification? = nil
}

public protocol HSVModifier {
  var adjustment: HSVAdjustment { get }
}

extension Array where Element == HSVAdjustment {
  public func combined(with strength: Double) -> HSVAdjustment {
    let combinedAdjustment: HSVAdjustment = self.reduce(.zero) {
      partialResult,
      adjustment in

      partialResult
        + .zero.interpolated(
          towards: adjustment,
          strength: strength
        )
    }
    return combinedAdjustment
  }
}

public struct ColourModification {
  let strength: ModificationStrengthPreset
  let purpose: ColourPurpose
  let chroma: ColourChroma

  public init(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma
  ) {
    self.strength = strength
    self.purpose = purpose
    self.chroma = chroma
  }
}

struct LuminanceModifier: HSVModifier {
  let threshold: LuminanceThreshold
  var adjustment: HSVAdjustment { threshold.adjustment }
}

struct ColourPurposeModifier: HSVModifier {
  let purpose: ColourPurpose
  var adjustment: HSVAdjustment { purpose.adjustment }
}

struct ChromaModifier: HSVModifier {
  let chroma: ColourChroma
  var adjustment: HSVAdjustment { chroma.adjustment }
}

public enum LuminanceThreshold {
  case dark
  case light

  public init(from colour: any ColourModel, using method: LuminanceMethod = .wcag) {
    self = colour.luminance(using: method) > 0.4 ? .light : .dark
  }
  var adjustment: HSVAdjustment {
    switch self {
      case .dark: HSVAdjustment(-18, -0.01, 0.75)
      case .light: HSVAdjustment(-16, 0.35, -0.75)
    }
  }

}

public enum ColourPurpose {
  case legibility
  case complimentary

  var adjustment: HSVAdjustment {
    switch self {
      case .legibility: HSVAdjustment(-6, -0.01, 0.1)
      case .complimentary: HSVAdjustment(-3, 0.1, 0.0)
    }
  }
}

public enum ColourChroma {
  case vibrant
  case saturated
  //  case saturated(CGFloat = 0.75)
  case standard
  case monochrome

  public var adjustment: HSVAdjustment {
    switch self {
      case .vibrant: HSVAdjustment(0, 0.7, 0)
      case .saturated: HSVAdjustment(0, 0.4, 0)
      case .standard: .zero
      case .monochrome: HSVAdjustment(0, -1.0, 0)
    }
  }
}
