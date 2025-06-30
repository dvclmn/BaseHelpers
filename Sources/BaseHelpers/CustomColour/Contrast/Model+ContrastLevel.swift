//
//  Model+ContrastLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

public struct ContrastLevel: Sendable {
  public var amount: Double
  
  public init(amount: Double) {
    self.amount = amount.clamped(to: 0...1)
  }
  
  // MARK: - Static presets (for convenience)
  
  public static let subtle = ContrastLevel(amount: 0.2)
  public static let moderate = ContrastLevel(amount: 0.4)
  public static let standard = ContrastLevel(amount: 0.7)
  public static let high = ContrastLevel(amount: 1.0)
  
  // MARK: - Internal constants
  
  private struct HSVComponents {
    var hueDegrees: Double
    var saturation: Double
    var brightness: Double
    
    static let zero = HSVComponents(hueDegrees: 0, saturation: 0, brightness: 0)
    
    func interpolated(to: HSVComponents, amount: Double) -> HSVComponents {
      .init(
        hueDegrees: hueDegrees + (to.hueDegrees - hueDegrees) * amount,
        saturation: saturation + (to.saturation - saturation) * amount,
        brightness: brightness + (to.brightness - brightness) * amount
      )
    }
    
    func asAdjustment(using strategy: (Double) -> HueAdjustmentStrategy) -> HSVAdjustment {
      HSVAdjustment(
        hueStrategy: strategy(hueDegrees),
        saturation: saturation,
        brightness: brightness
      )
    }
  }
  
  private static let maxDark = HSVComponents(
    hueDegrees: -17,
    saturation: 0.08,
    brightness: 0.7
  )
  
  private static let maxLight = HSVComponents(
    hueDegrees: -14,
    saturation: 0.2,
    brightness: -0.7
  )
  
  // MARK: - Computed Adjustments
  
  public var forDarkColours: HSVAdjustment {
    HSVComponents
      .zero
      .interpolated(to: Self.maxDark, amount: amount)
      .asAdjustment(using: { .relativeDegrees($0) })
  }
  
  public var forLightColours: HSVAdjustment {
    HSVComponents
      .zero
      .interpolated(to: Self.maxLight, amount: amount)
      .asAdjustment(using: { .relativeDegrees($0) })
  }
}
