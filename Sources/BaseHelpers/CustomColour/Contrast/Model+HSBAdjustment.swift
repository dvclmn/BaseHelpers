//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public enum HSVLuminanceType {
  case dark
  case light

  var baseContrastPreset: HSVAdjustment {
    switch self {
      case .dark:
        HSVAdjustment(
          hue: -22,
          saturation: 0.08,
          brightness: 0.7
        )

      case .light:
        HSVAdjustment(
          hue: -14,
          saturation: 0.2,
          brightness: -0.7
        )
    }
  }
}

public struct HSVAdjustment: Sendable {

  public var hue: Double
  //  public var hueStrategy: HueAdjustmentStrategy
  public var saturation: Double
  public var brightness: Double

  public static let zero = HSVAdjustment(h: 0, s: 0, b: 0)

  public init(
    hue: Double,
    //    hueStrategy: HueAdjustmentStrategy,
    saturation: Double,
    brightness: Double,
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
  }

}

extension HSVAdjustment {

  public static func forLightColours(contrastAmount: Double) -> HSVAdjustment {
    return HSVAdjustment.zero.interpolated(forType: .light, amount: contrastAmount)
  }

  public static func forDarkColours(contrastAmount: Double) -> HSVAdjustment {
    return HSVAdjustment.zero.interpolated(forType: .dark, amount: contrastAmount)
  }

  func interpolated(
    forType type: HSVLuminanceType,
    amount: Double,
  ) -> HSVAdjustment {
    let baseContrast = type.baseContrastPreset

    return HSVAdjustment(
      hue: doAThing(factor: amount, newAdjustment: baseContrast, for: .hue),
      saturation: doAThing(factor: amount, newAdjustment: baseContrast, for: .saturation),
      brightness: doAThing(factor: amount, newAdjustment: baseContrast, for: .brightness)

      //      hue: self.hue.doAThing(factor: amount, newValue: baseContrast.hue),
      //      saturation: self.saturation.doAThing(factor: amount, newValue: baseContrast.saturation),
      //      hue: self.hue.doAThing(factor: amount, newValue: baseContrast.hue),
      //      saturation: saturation + (baseContrast.saturation - saturation) * amount,
      //      brightness: brightness + (baseContrast.brightness - brightness) * amount
    )
  }

  //  private func thing(_ amount: Double) {
  //
  //  }

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
//extension BinaryFloatingPoint {
//  func doAThing(factor: Self, newValue: Self) -> Self {
//    let result = self + (newValue - self) * factor
//    return result
//  }
//}

//public enum HueAdjustmentStrategy: Sendable {
//
//  /// Add degrees to current hue (e.g. +180 flips hue)
//  case relativeDegrees(Double)
//
//  /// Set to a specific absolute hue in degrees [0, 360)
//  case fixedDegrees(Double)
//
//  /// Rotate hue by 180 degrees from current value
//  case rotate180
//
//  var reversed: HueAdjustmentStrategy {
//    switch self {
//      case .relativeDegrees(let degrees):
//        return .relativeDegrees(-degrees)
//
//      case .fixedDegrees(let fixed):
//        assertionFailure("Cannot automatically reverse fixed hue degrees")
//        /// Not clearly reversible — leave as-is, or up to user.
//        return .fixedDegrees(fixed)
//
//      case .rotate180:
//        return .rotate180
//    }
//  }

//  public func value(forHue hue: Double) -> HSVAdjustment {
//    let adjustedHue: Double = {
//      switch self {
//        case .relativeDegrees(let delta):
//          return (hue + delta / 360.0).hueWrapped()
//
//        case .fixedDegrees(let absolute):
//          return (absolute / 360.0).hueWrapped()
//
//        case .rotate180:
//          return (hue + 0.5).hueWrapped()
//      }
//    }()
//
//    return adjustedHue
//  }

//}

extension HSVAdjustment {
  public init(
    h hue: Double,
    s saturation: Double,
    b brightness: Double,
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
  }

  //  public init(
  //    hue: Double,
  //    saturation: Double,
  //    brightness: Double,
  //  ) {
  //    self.hueStrategy = .relativeDegrees(hue)
  //    self.saturation = saturation
  //    self.brightness = brightness
  //  }
}
