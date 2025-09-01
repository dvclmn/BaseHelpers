//
//  Model+LumaThreshold.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import Foundation

public enum LuminanceThreshold {
  case dark
  case light
  
  public init(
    from colour: any ColourModel,
    using method: LuminanceMethod = .wcag
  ) {
    self = colour.luminance(using: method) > 0.35 ? .light : .dark
  }
  
  /// A basic baseline adjustment based on what suits light vs dark colours
  var adjustment: HSVAdjustment {
    switch self {
      case .dark: HSVAdjustment(h: -18, s: -0.01, v: 0.75)
      case .light: HSVAdjustment(h: -16, s: 0.35, v: -0.75)
    }
  }
}
