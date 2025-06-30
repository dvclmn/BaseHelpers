//
//  LumaAwareAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public struct LuminanceAwareAdjustment: Sendable {
  public var light: HSVAdjustment
  public var dark: HSVAdjustment

  /// What luminance value is considered dark vs light
  public let luminanceTheshold: Double

  /// Provide *two* adjustments; one for use with Light contexts, one for Dark
  public init(
    light: HSVAdjustment,
    dark: HSVAdjustment,
    luminanceTheshold: Double = 0.5
  ) {
    self.light = light
    self.dark = dark
    self.luminanceTheshold = luminanceTheshold
  }

  /// Provide a *single* adjustment, which auto-inverts for Dark colours
//  public init(
//    symmetric adjustment: HSVAdjustment,
//    luminanceTheshold: Double = 0.5
//  ) {
//    self.light = adjustment
//    
//    self.dark = HSVAdjustment(
//      hueStrategy: adjustment.hueStrategy.reversed,
//      saturation: -adjustment.saturation,
//      brightness: -adjustment.brightness
//    )
//    
//    self.luminanceTheshold = luminanceTheshold
//  }
  //  public init(
//    symmetric adjustment: HSVAdjustment,
//    luminanceTheshold: Double = 0.5
//  ) {
//
//    self.light = adjustment
//    self.dark = HSVAdjustment(
//      hue: -adjustment,
//      saturation: -adjustment.saturation,
//      brightness: -adjustment.brightness,
//    )
//    self.luminanceTheshold = luminanceTheshold
//  }

  public func adjustment(forLuminance luminance: Double) -> HSVAdjustment {
    luminance > self.luminanceTheshold ? light : dark
  }

  public static func contrastPreset(
    _ preset: ContrastPreset,
    isMonochrome: Bool
  ) -> Self {
    return LuminanceAwareAdjustment(
      light: preset.adjustment(for: .light),
      dark: preset.adjustment(for: .dark)
//      light: preset.level(isMonochrome: isMonochrome).forLightColours,
//      dark: preset.level(isMonochrome: isMonochrome).forDarkColours
    )
  }
}
