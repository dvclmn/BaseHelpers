//
//  Model+ContrastLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

public struct ContrastLevel: Sendable {
  public var amount: Double
  private let isMonochrome: Bool
  
  public init(
    amount: Double,
    isMonochrome: Bool = false
  ) {
    self.amount = amount.clamped(to: 0...1)
    self.isMonochrome = isMonochrome
  }
  
  // MARK: - Static presets (for convenience)
  
//  public static let subtle = ContrastLevel(amount: 0.2), isMonochrome: <#T##Bool#>
//  public static let moderate = ContrastLevel(amount: 0.4, isMonochrome: <#T##Bool#>)
//  public static let standard = ContrastLevel(amount: 0.7, isMonochrome: <#T##Bool#>)
//  public static let high = ContrastLevel(amount: 1.0, isMonochrome: <#T##Bool#>)
  
  // MARK: - Internal constants
  
  private struct HSVComponents {
    var hueDegrees: Double
    var saturation: Double
    var brightness: Double
    
    static let zero = HSVComponents(hueDegrees: 0, saturation: 0, brightness: 0)
    
    func interpolated(
      to: HSVComponents,
      amount: Double,
      isMonochrome: Bool
    ) -> HSVComponents {
      
//      let lightSat: Double = 0.2
//      let darkSat: Double = 0.2
      let monochromeSat: Double = 0.2
      let newSaturation: Double = isMonochrome ? monochromeSat : (saturation + (to.saturation - saturation) * amount)
      
      return HSVComponents(
        hueDegrees: hueDegrees + (to.hueDegrees - hueDegrees) * amount,
        saturation: newSaturation,
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
    hueDegrees: -22,
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
      .interpolated(to: Self.maxDark, amount: amount, isMonochrome: self.isMonochrome)
      .asAdjustment(using: { .relativeDegrees($0) })
  }
  
  public var forLightColours: HSVAdjustment {
    HSVComponents
      .zero
      .interpolated(to: Self.maxLight, amount: amount, isMonochrome: self.isMonochrome)
      .asAdjustment(using: { .relativeDegrees($0) })
  }
}
