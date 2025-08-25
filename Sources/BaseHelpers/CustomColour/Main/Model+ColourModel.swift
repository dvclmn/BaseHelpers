//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
  var colourSpace: Color.RGBColorSpace { get }
  var swiftUIColor: Color { get }
  var alpha: Double { get set }
  mutating func opacity(_ opacity: Double)
  static func gray(_ brightness: Double, alpha: Double) -> Self
  func luminance(using method: LuminanceMethod) -> Double
  init(resolved: Color.Resolved)
}

// MARK: - Extension methods
extension ColourModel {

  public mutating func opacity(_ opacity: Double) {
    self.alpha = opacity
  }

  public var colourSpace: Color.RGBColorSpace { .sRGB }
}
