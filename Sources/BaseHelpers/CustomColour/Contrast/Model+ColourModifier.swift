//
//  Model+ColourModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation

public protocol HSVModifier {
  var adjustment: HSVAdjustment { get }
//  func adjustment(for colour: HSVColour) -> HSVAdjustment
}

public struct ColourModification {
  //  private let colour: HSVColour
//  let luminanceLevel: LuminanceLevel
  let strength: ModificationStrengthPreset
  let purpose: ColourPurpose
  let chroma: ColourChroma
  
  public init(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma
  ) {
    self.strength = strength
    self.purpose = purpose
    self.chroma = chroma
  }
}

/// Should take in either a preset `ContrastPreset`, or a
/// float value adjustment amount.
/// Returns a modified `RGBColour`
//public struct ColourModification {
////  private let colour: HSVColour
//  let luminanceLevel: LuminanceLevel
//  let strength: CGFloat
//  let purpose: ColourPurpose
//  let chroma: ColourChroma
//
//  public init(
////    colour: HSVColour,
//    luminanceLevel: LuminanceLevel,
//    strength: CGFloat,
//    purpose: ColourPurpose = .legibility,
//    chroma: ColourChroma = .standard
//  ) {
////    self.colour = colour
//    self.luminanceLevel = luminanceLevel
//    self.strength = strength
//    self.purpose = purpose
//    self.chroma = chroma
//  }
//
//  public init(
////    colour: HSVColour,
//    luminanceLevel: LuminanceLevel,
//    preset: ModificationStrengthPreset,
//    purpose: ColourPurpose = .legibility,
//    chroma: ColourChroma = .standard
//  ) {
//    self.init(
////      colour: colour,
//      luminanceLevel: luminanceLevel,
//      strength: preset.adjustmentStrength,
//      purpose: purpose,
//      chroma: chroma
//    )
//  }
//}

extension ColourModification {

  
//  var luminance: Double {
//    return colour.luminance
//  }
}
