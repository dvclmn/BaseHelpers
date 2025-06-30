//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public enum ContrastPurpose {
  case legibility
  case complimentary
}

public enum LuminanceLevel {
  case dark
  //  case mid
  case light

  public init(from luminance: Double) {
    if luminance > 0.4 {
      self = .light
      //    } else if luminance > 0.3 {
      //      self = .mid
    } else {
      self = .dark
    }
  }

  func baseContrastPreset(purpose: ContrastPurpose) -> HSVAdjustment {
    switch self {
      case .dark:
        switch purpose {
          case .legibility:
            HSVAdjustment(
              hue: -19,
              saturation: -0.09,
              brightness: 0.7
            )
          case .complimentary:
            HSVAdjustment(
              hue: -19,
              saturation: -0.09,
              brightness: 0.7
            )

        }

      //      case .mid:
      //        HSVAdjustment(
      //          hue: -16,
      //          saturation: -0.01,
      //          brightness: 0.1
      //        )

      case .light:
        switch purpose {
          case .legibility:
            HSVAdjustment(
              hue: -12,
              saturation: 0.25,
              brightness: -0.7
            )
          case .complimentary:
            HSVAdjustment(
              hue: -12,
              saturation: 0.25,
              brightness: -0.7
            )
        }
    }
  }
}

public struct HSVAdjustment: Sendable {

  public var hue: Double
  public var saturation: Double
  public var brightness: Double

  public static let zero = HSVAdjustment(h: 0, s: 0, b: 0)

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

  public static func adjustment(
    forLumaLevel level: LuminanceLevel,
    contrastAmount: Double,
    purpose: ContrastPurpose
  ) -> HSVAdjustment {
    self.zero.interpolated(forLevel: level, amount: contrastAmount, purpose: purpose)
  }

  //  public static func forLightColours(contrastAmount: Double) -> HSVAdjustment {
  //    return HSVAdjustment.zero.interpolated(forType: .light, amount: contrastAmount)
  //  }
  //
  //  public static func forDarkColours(contrastAmount: Double) -> HSVAdjustment {
  //    return HSVAdjustment.zero.interpolated(forType: .dark, amount: contrastAmount)
  //  }

  func interpolated(
    forLevel level: LuminanceLevel,
    amount: Double,
    purpose: ContrastPurpose
  ) -> HSVAdjustment {
    let baseContrast = level.baseContrastPreset(purpose: purpose)

    return HSVAdjustment(
      hue: doAThing(factor: amount, newAdjustment: baseContrast, for: .hue),
      saturation: doAThing(factor: amount, newAdjustment: baseContrast, for: .saturation),
      brightness: doAThing(factor: amount, newAdjustment: baseContrast, for: .brightness)
    )
  }

  func doAThing(
    factor: Double,
    newAdjustment: HSVAdjustment,
    for component: HSVComponent
  ) -> Double {
    let existingValue: Double = self[keyPath: component.hsvAdjustmentPath]
    let newValue: Double = newAdjustment[keyPath: component.hsvAdjustmentPath]
    let result = existingValue + (newValue - existingValue) * factor
    return result
  }
}

extension HSVAdjustment {
  public init(
    h hue: Double,
    s saturation: Double,
    b brightness: Double,
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
  }

}
