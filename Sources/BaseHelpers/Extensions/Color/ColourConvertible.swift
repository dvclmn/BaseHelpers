//
//  ColourConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

/// The goal here is to unify some common colour-related types,
/// namely SwiftUI's `Color`, my `RGBColour`,
/// `NamedColour` and `Swatch`.
public protocol ColourConvertible: Sendable {

  var swiftUIColour: Color { get }

  func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma,
    //    environment: EnvironmentValues?
  ) -> Color
}

// MARK: - Color
extension Color: ColourConvertible {
  public var swiftUIColour: Color { self }

  //  public func contrastColour(
  //    strength: ModificationStrengthPreset,
  //    purpose: ColourPurpose = .legibility,
  //    chroma: ColourChroma = .standard,
  ////    environment: EnvironmentValues? = nil
  //  ) -> Color {
  //
  //    guard let environment else { return nil }
  //
  //    return self.contrastColour(
  //      strength: strength,
  //      purpose: purpose,
  //      chroma: chroma,
  //      environment: environment
  //    ).swiftUIColour
  //  }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    //    environment: EnvironmentValues
  ) -> Color {

    let hsvColour = HSVColour(colour: self, environment: environment)
    let adjustment = HSVAdjustment.applyingModifiers(
      for: hsvColour,
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )

    let adjustedHSV = hsvColour.applying(adjustment: adjustment)

    return adjustedHSV.swiftUIColour
  }
}

// MARK: - RGBColour
extension RGBColour: ColourConvertible {

}

// MARK: - Swatch
extension Swatch: ColourConvertible {
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    //    environment: EnvironmentValues? = nil
  ) -> Color {

    //    guard let environment else { return nil }
    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
    ).swiftUIColour
  }

}
