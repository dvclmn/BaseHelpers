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

struct LuminanceLevelAdjustment: HSVModifier {
  let level: LuminanceLevel
  var adjustment: HSVAdjustment {
    switch level {
      case .dark: HSVAdjustment(-18, -0.01, 0.75)
      case .light: HSVAdjustment(-16, 0.35, -0.75)
    }
  }
}

struct ColourPurposeAdjustment: HSVModifier {
  let purpose: ColourPurpose
  var adjustment: HSVAdjustment {
    switch purpose {
      case .legibility: HSVAdjustment(-6, -0.01, 0.1)
      case .complimentary: HSVAdjustment(-3, 0.1, 0.0)
    }
  }
}

struct ChromaAdjustment: HSVModifier {
  let chroma: ColourChroma
  var adjustment: HSVAdjustment {
    switch chroma {
      case .vibrant: HSVAdjustment(0, 0.8, 0)
      case .saturated: HSVAdjustment(0, 0.55, 0)
      case .standard: .zero
      case .monochrome: HSVAdjustment(0, -1.0, 0)
    }
  }
}

public enum LuminanceLevel {
  case dark
  case light

  public init(from colour: any ColourModel) {
    self = colour.luminance > 0.4 ? .light : .dark
  }
}

public enum ColourPurpose {
  case legibility
  case complimentary
}

public enum ColourChroma {
  case vibrant
  case saturated
//  case saturated(CGFloat = 0.75)
  case standard
  case monochrome
}
