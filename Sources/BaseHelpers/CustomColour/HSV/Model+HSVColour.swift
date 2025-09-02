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

  public var hue: UnitIntervalCyclic
  public var saturation: UnitInterval
  public var brightness: UnitInterval
  public var alpha: UnitInterval
  public var name: String?

  public var swiftUIColour: Color {
    Color(
      hue: hue.value,
      saturation: saturation.value,
      brightness: brightness.value,
      opacity: alpha.value
    )
  }

  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
    alpha: Double = 1.0,
    name: String? = nil
  ) {
    self.init(
      hueCyclic: hue.toUnitIntervalCyclic,
      saturation: saturation.toUnitInterval,
      brightness: brightness.toUnitInterval,
      alpha: alpha.toUnitInterval,
      name: name
    )
  }

  public init(
    hueCyclic: UnitIntervalCyclic,
    saturation: UnitInterval,
    brightness: UnitInterval,
    alpha: UnitInterval = 1.0,
    name: String? = nil
  ) {

    self.hue = hueCyclic
    self.saturation = saturation
    self.brightness = brightness
    self.alpha = alpha
    self.name = name

  }

  public init(
    colour: Color,
    environment: EnvironmentValues,
    name: String?
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(resolved: resolved, name: name ?? colour.colourName)
  }

  public init(
    resolved: Color.Resolved,
    name: String?
  ) {
    let rgba = RGBColour(resolved: resolved, name: name)
    self.init(fromRGB: rgba)
  }

}

extension HSVColour {

  public var hueDegrees: Double { hue.degrees }

  public var toRGB: RGBColour { RGBColour(fromHSV: self) }

  public func luminance(using method: LuminanceMethod = .wcag) -> Double {
    RGBColour(fromHSV: self).luminance(using: method)
  }

  public func luminanceThreshold(using method: LuminanceMethod) -> LuminanceThreshold {
    RGBColour(fromHSV: self).luminanceThreshold(using: method)
  }

  public static func gray(
    _ brightness: Double,
    alpha: Double = 1.0,
    //    name: String?
  ) -> HSVColour {
    return HSVColour(
      hue: 0,
      saturation: 0,
      brightness: brightness,
      alpha: alpha,
      name: nil
    )
  }

  func applying(adjustment: HSVAdjustment) -> HSVColour {

    //    let adjustedHue: UnitIntervalCyclic
    //    if let hueAdj = adjustment.hue {
    //      adjustedHue = (hue.value + hueAdj / 360.0).hueWrapped()
    //    } else {
    //      adjustedHue = hue.value
    //    }

    let adjustedHue = adjustment.hue.map { hue + $0 } ?? hue

    let adjustedSaturation =
      adjustment.saturation.map { saturation + $0 } ?? saturation

    let adjustedBrightness =
      adjustment.brightness.map { brightness + $0 } ?? brightness

    return HSVColour(
      hueCyclic: adjustedHue,
      saturation: adjustedSaturation,
      brightness: adjustedBrightness,
      alpha: alpha,
      name: self.name
    )
  }

  public static func + (lhs: HSVColour, rhs: HSVAdjustment) -> HSVColour {
    lhs.applying(adjustment: rhs)
  }
}
