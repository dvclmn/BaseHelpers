//
//  Model+LumaLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation

public enum ContrastPurpose {
  case legibility
  case complimentary
}

public enum ContrastChroma {
  case saturated
  case standard
  case monochrome
}

public enum LuminanceLevel {
  case dark
  case light
  
  public init(from luminance: Double) {
    self = luminance > 0.4 ? .light : .dark
  }
  
  func baseContrastPreset(purpose: ContrastPurpose) -> HSVAdjustment {
    switch self {
      case .dark:
        switch purpose {
          case .legibility:
            HSVAdjustment(
              hue: -18,
              saturation: -0.01,
              brightness: 0.75
            )
            
          case .complimentary:
            HSVAdjustment(
              hue: -22,
              saturation: -0.08,
              brightness: 0.65
            )
        }
        
      case .light:
        switch purpose {
          case .legibility:
            HSVAdjustment(
              hue: -16,
              saturation: 0.35,
              brightness: -0.75
            )
          case .complimentary:
            HSVAdjustment(
              hue: -10,
              saturation: 0.3,
              brightness: -0.5
            )
        }
    }
  }
}
