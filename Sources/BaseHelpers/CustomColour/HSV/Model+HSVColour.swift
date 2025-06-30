//
//  Model+HSV.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct HSVColour: Equatable, Sendable, ColourModel {

  public var hue: Double
  public var saturation: Double
  public var brightness: Double
  public var alpha: Double

  public var nativeColour: Color {
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

  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> HSVColour {
    return HSVColour(hue: 0, saturation: 0, brightness: brightness, alpha: alpha)
  }

  public func componentBarWidth(
    _ component: HSVComponent,
    in fullWidth: CGFloat
  ) -> CGFloat {
    let value = self[keyPath: component.keyPath]
    let result = value.normalised(against: fullWidth, isClamped: true)
    return result * 100
  }
  
  func applying(adjustment: HSVAdjustment) -> HSVColour {
    let adjustedHue: Double = {
      switch adjustment.hueStrategy {
        case .relativeDegrees(let delta):
          return (hue + delta / 360.0).hueWrapped()

        case .fixedDegrees(let absolute):
          return (absolute / 360.0).hueWrapped()

        case .rotate180:
          return (hue + 0.5).hueWrapped()
      }
    }()

    let newSaturation = (saturation + adjustment.saturation).clamped(to: 0...1)
    let newBrightness = (brightness + adjustment.brightness).clamped(to: 0...1)

    return HSVColour(
      hue: adjustedHue,
      saturation: newSaturation,
      brightness: newBrightness,
      alpha: alpha
    )
  }

  //  func applying(adjustment: HSVAdjustment) -> HSVColour {
  //
  //    let newHue = (hue + adjustment.hue / 360.0).hueWrapped()
  //
  //    let newSaturation = (saturation + adjustment.saturation).clamped(to: 0...1)
  //    let newBrightness = (brightness + adjustment.brightness).clamped(to: 0...1)
  //
  //    return HSVColour(
  //      hue: newHue,
  //      saturation: newSaturation,
  //      brightness: newBrightness,
  //      alpha: alpha
  //    )
  //  }
}
