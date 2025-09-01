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
    self = colour.luminance(using: method) > 0.4 ? .light : .dark
  }
  
  /// A basic baseline adjustment based on what suits light vs dark colours
  var adjustment: HSVAdjustment {
    switch self {
      case .dark: HSVAdjustment(-18, -0.01, 0.75)
      case .light: HSVAdjustment(-16, 0.35, -0.75)
    }
  }
}
