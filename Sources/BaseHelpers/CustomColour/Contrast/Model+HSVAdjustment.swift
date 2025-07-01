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
  public init(
    _ hue: Double,
    _ saturation: Double,
    _ brightness: Double,
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
  }
}

extension HSVAdjustment {
  
  static func + (lhs: HSVAdjustment, rhs: HSVAdjustment) -> HSVAdjustment {
    HSVAdjustment(
      hue: lhs.hue + rhs.hue,
      saturation: lhs.saturation + rhs.saturation,
      brightness: lhs.brightness + rhs.brightness
    )
  }
  
  func scaled(by factor: Double) -> HSVAdjustment {
    HSVAdjustment(
      hue: hue * factor,
      saturation: saturation * factor,
      brightness: brightness * factor
    )
  }
  
  /// Now with this, `HSVAdjustment` knows how to go from
  /// one instance of itself, to another, linearly interpolating.
  ///
  /// The key here is that a `HSVAdjustment` describes
  /// the properties neccesary to actually *change* a given colour.
  /// These values/presets are described elsewhere, such as
  /// `ColourModification` and `ContrastPreset` etc.
  ///
  /// But here, we can go from one, to another, which is very useful.
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
  
//  public func adjustComponent(
//
//  )
}
