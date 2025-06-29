//
//  Model+HSBAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public struct HSBAdjustment: Sendable {
  public var hue: Double  // Degrees
  public var saturation: Double
  public var brightness: Double

  /// What luminance value is considered dark vs light
  //  public var luminanceTheshold: Double

  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
    //    luminanceTheshold: Double = 0.5
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    //    self.luminanceTheshold = luminanceTheshold
  }
  public init(
    h hue: Double,
    s saturation: Double,
    b brightness: Double,
    //    luminanceTheshold: Double = 0.5
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
    //    self.luminanceTheshold = luminanceTheshold
  }
}
