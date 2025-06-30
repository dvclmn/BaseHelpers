//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public enum HueAdjustmentStrategy: Sendable {

  /// Add degrees to current hue (e.g. +180 flips hue)
  case relativeDegrees(Double)

  /// Set to a specific absolute hue in degrees [0, 360)
  case fixedDegrees(Double)

  /// Rotate hue by 180 degrees from current value
  case rotate180

  var reversed: HueAdjustmentStrategy {
    switch self {
      case .relativeDegrees(let degrees):
        return .relativeDegrees(-degrees)
        
      case .fixedDegrees(let fixed):
        assertionFailure("Cannot automatically reverse fixed hue degrees")
        // Not clearly reversible — leave as-is, or up to user.
        return .fixedDegrees(fixed)
        
      case .rotate180:
        return .rotate180
    }
  }
  
}

public struct HSVAdjustment: Sendable {
  public var hueStrategy: HueAdjustmentStrategy
  public var saturation: Double
  public var brightness: Double

  
  
//  public var hue: Double {
//
//    switch hueStrategy {
//      case .relativeDegrees(let delta):
//        return (hue + delta / 360.0).hueWrapped()
//
//      case .fixedDegrees(let absolute):
//        return (absolute / 360.0).hueWrapped()
//
//      case .rotate180:
//        return (hue + 0.5).hueWrapped()
//    }
//
//  }

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
