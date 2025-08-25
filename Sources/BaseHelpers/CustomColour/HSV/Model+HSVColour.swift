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
  
  public var toRGB: RGBColour {
    RGBColour(fromHSV: self)
  }

  public func luminance(using method: LuminanceMethod = .wcag) -> Double {
    RGBColour(fromHSV: self).luminance(using: method)
  }
  
  public var luminanceThreshold: LuminanceThreshold {
    RGBColour(fromHSV: self).luminanceThreshold
  }

  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> HSVColour {
    return HSVColour(hue: 0, saturation: 0, brightness: brightness, alpha: alpha)
  }

  //  public func componentBarWidth(
  //    _ component: HSVComponent,
  //    in range: ClosedRange<Double>
  ////    in fullWidth: CGFloat
  //  ) -> CGFloat {
  //    let value = self[keyPath: component.keyPath]
  //    let result = value.normalised(from: range)
  ////    let result = value.normalised(against: fullWidth, isClamped: true)
  //    return result
  ////    return result * 100
  //  }

  func applying(adjustment: HSVAdjustment) -> HSVColour {
    let adjustedHue: Double = (hue + adjustment.hue / 360.0).hueWrapped()

    let newSaturation = (saturation + adjustment.saturation).clamped(to: 0...1)
    let newBrightness = (brightness + adjustment.brightness).clamped(to: 0...1)

    return HSVColour(
      hue: adjustedHue,
      saturation: newSaturation,
      brightness: newBrightness,
      alpha: alpha
    )
  }

}
