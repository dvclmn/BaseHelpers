//
//  Model+Components.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

/// Notes on differences in modelling RGB vs HSB
///
/// For HSV, these aren't "channels" in the same sense as
/// RGB components. They represent different types of color attributes:
///
/// - Hue is an angular dimension (0-360 degrees)
/// - Saturation is a percentage of color intensity (0-100%)
/// - Value/Brightness is a percentage of lightness (0-100%)

public enum HSVComponent: String, ColourComponent {

  public typealias Model = HSVColour

  case hue
  case saturation
  case brightness
  case alpha

  public var keyPath: WritableKeyPath<Model, Double> {
    switch self {
      case .hue: \.hue
      case .saturation: \.saturation
      case .brightness: \.brightness
      case .alpha: \.alpha
    }
  }

  public func gradientColours(_ colour: Model) -> [Color] {
    switch self {
      case .hue: Array<Color>.rainbow
      case .saturation:
        [.gray, colour.nativeColour]
      case .brightness:
        [.black, .white]
      case .alpha:
        [.clear, colour.nativeColour]
    }
  }

  public func sliderTrackGradient(colour: HSVColour) -> LinearGradient {
    return LinearGradient(
      colors: self.gradientColours(colour),
      startPoint: .leading,
      endPoint: .trailing
    )
  }

}
