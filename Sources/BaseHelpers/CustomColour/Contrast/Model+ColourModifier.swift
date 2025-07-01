//
//  Model+ColourModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation

/// Should take in either a preset `ContrastPreset`, or a
/// float value adjustment amount.
/// Returns a modified `RGBColour`
public struct ColourModification {
  var strength: CGFloat
  var purpose: ContrastPurpose
  var chroma: ContrastChroma
  
  public init(
    strength: CGFloat,
    purpose: ContrastPurpose = .legibility,
    chroma: ContrastChroma = .standard
  ) {
    self.strength = strength
    self.purpose = purpose
    self.chroma = chroma
  }
  
  public init(
    preset: ContrastPreset,
    purpose: ContrastPurpose = .legibility,
    chroma: ContrastChroma = .standard
  ) {
    self.strength = preset.contrastValue
    self.purpose = purpose
    self.chroma = chroma
  }
}

extension ColourModification {
  
}
