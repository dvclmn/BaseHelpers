//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public enum HueAdjustmentStrategy: Sendable {
  /// Adjust by degrees
  case relativeDegrees(Double)
  
  /// for hard contrast
  case rotate180
  
  /// set to an explicit hue
  case fixedHue(Double)
}

public struct HSVAdjustment: Sendable {
  public var hueStrategy: HueAdjustmentStrategy
  public var saturation: Double
  public var brightness: Double

  public init(
    hueStrategy: HueAdjustmentStrategy,
    saturation: Double,
    brightness: Double,
  ) {
    self.hueStrategy = hueStrategy
    self.saturation = saturation
    self.brightness = brightness
  }
  
  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
  ) {
    self.hueStrategy = .relativeDegrees(hue)
    self.saturation = saturation
    self.brightness = brightness
  }
  public init(
    h hue: Double,
    s saturation: Double,
    b brightness: Double,
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
  }
}
