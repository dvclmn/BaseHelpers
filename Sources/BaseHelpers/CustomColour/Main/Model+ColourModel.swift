//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
  var colourSpace: Color.RGBColorSpace { get }
  var name: String? { get }
  var swiftUIColour: Color { get }
  var alpha: UnitInterval { get set }
  mutating func opacity(_ opacity: Double)
  static func gray(_ brightness: Double, alpha: Double) -> Self
  func luminance(using method: LuminanceMethod) -> Double
  func luminanceThreshold(using method: LuminanceMethod) -> LuminanceThreshold
  init(resolved: Color.Resolved, name: String?)
}

// MARK: - Extension methods
extension ColourModel {
  public mutating func opacity(_ opacity: Double) { alpha = opacity.toUnitInterval }
  public var colourSpace: Color.RGBColorSpace { .sRGB }
}
