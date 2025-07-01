//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

/// Represents a *delta* adjustment in HSV space
/// Does not set hsb values to these, but adds to them
public struct HSVAdjustment: Sendable {
  public var hue: Double
  public var saturation: Double
  public var brightness: Double

  public static let zero = HSVAdjustment(
    hue: 0,
    saturation: 0,
    brightness: 0
  )

  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
  }

}

extension HSVAdjustment {
  
  func interpolated(
    towards other: HSVAdjustment,
    strength: Double
  ) -> HSVAdjustment {
    let current = self
    let new = other
    
    let adjusted = HSVAdjustment(
      hue: lerp(from: current.hue, to: new.hue, strength),
      saturation: lerp(from: current.saturation, to: new.saturation, strength),
      brightness: lerp(from: current.brightness, to: new.brightness, strength)
    )
    return adjusted
  }
}
