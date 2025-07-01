//
//  Model+LumaLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation

struct LuminanceLevelAdjustment: HSVModifier {
  let level: LuminanceLevel
  func adjustment(for colour: HSVColour) -> HSVAdjustment {
    switch level {
      case .dark: HSVAdjustment(-18, -0.01, 0.75)
      case .light: HSVAdjustment(-16, 0.35, -0.75)
    }
  }
}

struct ColourPurposeAdjustment: HSVModifier {
  let purpose: ColourPurpose
  func adjustment(for colour: HSVColour) -> HSVAdjustment {
    switch purpose {
      case .legibility: HSVAdjustment(-6, -0.01, 0.1)
      case .complimentary: HSVAdjustment(-3, 0.1, 0.0)
    }
  }
}

struct ChromaAdjustment: HSVModifier {
  let chroma: ColourChroma
  func adjustment(for colour: HSVColour) -> HSVAdjustment {
    switch chroma {
      case .saturated: HSVAdjustment(0, 0.15, 0)
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
  case saturated
  case standard
  case monochrome
}
