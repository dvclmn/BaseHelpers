//
//  Model+HSV.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

/// Notes:
/// In HSV, brightness (value) is the *maximum* of the RGB channels.
/// But luminance is a weighted sum of the linearised RGB values,
/// which means:
/// -  Two colours with the same HSV value might have
///   wildly different luminance.
/// -  Luminance depends on how the three channels contribute
///   based on human perception.
public struct HSVColour: Equatable, Sendable, ColourModel {

  /// Kept normalised `1...0` internally.
  /// Trivially convertable to degrees (0-360) for UI as needed
  public var hue: Double
  public var saturation: Double
  public var brightness: Double
  public var alpha: Double

  public var swiftUIColor: Color {
    Color(
      hue: hue,
      saturation: saturation,
      brightness: brightness,
      opacity: alpha
    )
  }

  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
    alpha: Double
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.alpha = alpha
  }

  public init(
    colour: Color,
    environment: EnvironmentValues
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(resolved: resolved)
  }

  public init(resolved: Color.Resolved) {
    let rgba = RGBColour(resolved: resolved)
    self.init(fromRGB: rgba)
  }

}

extension HSVColour {

  public var hueDegrees: Double { hue * 360.0 }

  public var toRGB: RGBColour {
    RGBColour(fromHSV: self)
  }

  public func luminance(using method: LuminanceMethod = .wcag) -> Double {
    RGBColour(fromHSV: self).luminance(using: method)
  }

  public func luminanceThreshold(using method: LuminanceMethod) -> LuminanceThreshold {
    RGBColour(fromHSV: self).luminanceThreshold(using: method)
  }

  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> HSVColour {
    return HSVColour(hue: 0, saturation: 0, brightness: brightness, alpha: alpha)
  }

  func applying(adjustment: HSVAdjustment) -> HSVColour {
    let adjustedHue: Double
    if let hueAdj = adjustment.hue {
      adjustedHue = (hue + hueAdj / 360.0).hueWrapped()
    } else {
      adjustedHue = hue
    }

    let adjustedSaturation =
      adjustment.saturation.map {
        (saturation + $0).clamped(to: 0...1)
      } ?? saturation

    let adjustedBrightness =
      adjustment.brightness.map {
        (brightness + $0).clamped(to: 0...1)
      } ?? brightness

    return HSVColour(
      hue: adjustedHue,
      saturation: adjustedSaturation,
      brightness: adjustedBrightness,
      alpha: alpha
    )
  }

  public static func + (lhs: HSVColour, rhs: HSVAdjustment) -> HSVColour {
    lhs.applying(adjustment: rhs)
  }
}
