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
  private let colour: any ColourModel
  let strength: CGFloat
  let luminance: LuminanceLevel
  let purpose: ContrastPurpose
  let chroma: ContrastChroma
  
  public init(
    colour: any ColourModel,
    strength: CGFloat,
    purpose: ContrastPurpose = .legibility,
    chroma: ContrastChroma = .standard
  ) {
    self.colour = colour
    self.strength = strength
    self.luminance = luminance
    self.purpose = purpose
    self.chroma = chroma
  }
  
  public init(
    colour: any ColourModel,
    preset: ContrastPreset,
    purpose: ContrastPurpose = .legibility,
    chroma: ContrastChroma = .standard
  ) {
    self.colour = colour
    self.strength = preset.contrastValue
    self.luminance = colour.luminance
    self.purpose = purpose
    self.chroma = chroma
  }
}

extension ColourModification {
  
}
