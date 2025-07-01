//
//  Model+RGB.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct RGBColour: Identifiable, Equatable, Hashable, Sendable, Codable, ColourModel {
  public let id: UUID
  public var red: Double
  public var green: Double
  public var blue: Double
  public var alpha: Double

  /// Thinking of trying storing a resolved colour, so I don't have to get Env values if not needed?

  public init(
    colour: Color,
    environment: EnvironmentValues,
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
    )
  }

  public var nativeColour: Color {
    Color(
      colourSpace,
      red: red,
      green: green,
      blue: blue,
      opacity: alpha
    )
  }

  public init(
    resolved: Color.Resolved,
  ) {
    self.init(
      red: resolved.red.toDouble, green: resolved.green.toDouble, blue: resolved.blue.toDouble,
      alpha: resolved.opacity.toDouble)
  }

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0,
  ) {
    self.id = UUID()
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }

  //  public init(
  //    fromSwatch swatch: Swatch,
  //    environment: EnvironmentValues
  //  ) {
  //    self.init(
  //      colour: swatch.colour,
  //      environment: environment
  //    )
  //    self.originalSwatch = swatch
  //  }

}

extension RGBColour {

  public var toHSV: HSVColour {
    HSVColour(fromRGB: self)
  }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard
  ) -> RGBColour {

    let hsvColour = HSVColour(fromRGB: self)

//    let modification = ColourModification(
//      strength: strength,
//      purpose: purpose,
//      chroma: chroma
//    )
    
    let adjustment: HSVAdjustment = {
      let contributors: [any HSVModifier] = [
        LuminanceLevelAdjustment(level: self.luminanceLevel),
        ColourPurposeAdjustment(purpose: purpose),
        ChromaAdjustment(chroma: chroma),
      ]
      
      //    var adjustment: HSVAdjustment {
      
      
      let allAdjustments: [HSVAdjustment] = contributors.map { modifier in
        modifier.adjustment
      }
      
      let combinedAdjustment: HSVAdjustment = allAdjustments.reduce(.zero) { partialResult, adjustment in
        partialResult + .zero.interpolated(towards: adjustment, strength: strength.adjustmentStrength)
      }
      
      return combinedAdjustment
      
    }()
    
//    let modification = ColourModification(
//      luminanceLevel: hsvColour.luminanceLevel,
////      colour: hsvColour,
//      strength: strength,
//      purpose: purpose,
//      chroma: chroma
//    )
//    print("HSVModification is: \(modification)")
    let adjustedHSV = hsvColour.applying(adjustment: adjustment)
    return adjustedHSV.toRGB
  }

  public func contrastColour(modification: ColourModification?) -> RGBColour {
    guard let modification else { return self }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma
    )
  }

  //  public func contrastColour(
  //    withPreset preset: ContrastPreset,
  //    purpose: ContrastPurpose = .legibility,
  //    isMonochrome: Bool = false
  //  ) -> RGBColour {
  //
  //    let hsvColour = HSVColour(fromRGB: self)
  //    let adjustmentToApply = preset.adjustment(
  //      for: self.luminanceLevel,
  //      purpose: purpose
  //    )
  //
  //    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
  //    return RGBColour(fromHSV: newHSV)
  //  }

  public var luminanceLevel: LuminanceLevel {
    return LuminanceLevel(from: self)
  }

  public init(
    r: Double,
    g: Double,
    b: Double,
    a: Double = 1.0,
  ) {
    self.init(red: r, green: g, blue: b, alpha: a)
  }

  func linearised(_ channel: Double) -> Double {
    return channel <= 0.04045
      ? channel / 12.92
      : pow((channel + 0.055) / 1.055, 2.4)
  }

  public var luminance: Double {
    let r = linearised(red)
    let g = linearised(green)
    let b = linearised(blue)
    return (0.2126 * r + 0.7152 * g + 0.0722 * b).clamped(to: 0...1)
  }

  /// Create a color with specified brightness (0.0 to 1.0)
  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> RGBColour {
    return RGBColour(
      red: brightness,
      green: brightness,
      blue: brightness,
      alpha: alpha
    )
  }

}
