//
//  Model+ColourModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation

public protocol HSVModifier {
  func adjustment(for colour: HSVColour) -> HSVAdjustment
}

/// Should take in either a preset `ContrastPreset`, or a
/// float value adjustment amount.
/// Returns a modified `RGBColour`
public struct ColourModification {
  private let colour: HSVColour
  let strength: CGFloat
  let purpose: ColourPurpose
  let chroma: ColourChroma

  public init(
    colour: HSVColour,
    strength: CGFloat,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard
  ) {
    self.colour = colour
    self.strength = strength
    self.purpose = purpose
    self.chroma = chroma
  }

  public init(
    colour: HSVColour,
    preset: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard
  ) {
    self.init(
      colour: colour,
      strength: preset.adjustmentStrength,
      purpose: purpose,
      chroma: chroma
    )
  }
}

extension ColourModification {

  func adjusted() -> HSVColour {

    let contributors: [any HSVModifier] = [
      LuminanceLevelAdjustment(level: self.colour.luminanceLevel),
      ColourPurposeAdjustment(purpose: self.purpose),
      ChromaAdjustment(chroma: self.chroma),
    ]

    let totalAdjustment: HSVAdjustment
    for contributor in contributors {
      let newAdjustment = contributor.adjustment(for: colour)
      newAdjustment.
    }
    
//    let totalAdjustment: HSVAdjustment =
//      contributors
//      .map { $0.adjustment(for: colour) }
//      .reduce(.zero) { partialResult, adjustment in
//        let addedResult = partialResult + adjustment
//        return addedResult.interpolated(towards: adjustment, strength: self.strength)
//      }
//      .reduce(.zero, +)

    let adjustedColour = self.colour.applying(adjustment: totalAdjustment)
    return adjustedColour

  }

  var luminance: Double {
    return colour.luminance
  }
}
