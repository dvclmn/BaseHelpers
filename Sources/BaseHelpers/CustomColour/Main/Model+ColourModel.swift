//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
  var colourSpace: Color.RGBColorSpace { get }
  var componentRange: ClosedRange<Double> { get }
  var nativeColour: Color { get }
  var alpha: Double { get set }
  
  mutating func opacity(_ opacity: Double)
  static func gray(_ brightness: Double, alpha: Double = 1.0) -> Self
  
  init(resolved: Color.Resolved)
}

// MARK: - Extension methods
extension ColourModel {
  
  public mutating func opacity(_ opacity: Double) {
    self.alpha = opacity
  }
  
  public var componentRange: ClosedRange<Double> { 0...1 }
  
  /// Note: I found that using RBGLinear did *not* look right
  public var colourSpace: Color.RGBColorSpace { .sRGB }
}

public enum ColourModelType: String {
  case linearRGB
  case hsv
}
