//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

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

  public static func adjustment(
    forLumaLevel level: LuminanceLevel,
    contrastAmount: Double,
    purpose: ContrastPurpose
  ) -> HSVAdjustment {
    self.zero.interpolated(forLevel: level, amount: contrastAmount, purpose: purpose)
  }

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
