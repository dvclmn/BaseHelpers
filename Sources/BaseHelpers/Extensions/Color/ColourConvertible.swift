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
public protocol ColourConvertible: Sendable, Identifiable {
  var id: Self.ID { get }
  var name: String? { get }
  var swiftUIColour: Color { get }

  /// Includes optional `environment`, as `Color`
  /// needs this to resolve itself first. If `nil`, `Color`
  /// will return it's `self`, unmodified.
  func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma,
    environment: EnvironmentValues?
  ) -> Color

  func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues?
  ) -> Color
}

// MARK: - Color
extension Color: @retroactive Identifiable {
  public var id: Int { self.hashValue }
  public var name: String? { nil }
}

extension Color: ColourConvertible {

  //  public var id: String { self.description }
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
    environment: EnvironmentValues?
  ) -> Color {

    guard let environment else {
      print("⚠️ Warning: Contrast colour was returned *unmodified* as no value was provided for `environment`.")
      return self
    }

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
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma,
    environment: EnvironmentValues? = nil
  ) -> Color {
    return self.contrastColour(strength: strength, purpose: purpose, chroma: chroma).swiftUIColour
  }
}

// MARK: - Swatch
extension Swatch: ColourConvertible {
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    environment: EnvironmentValues? = nil
  ) -> Color {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    ).swiftUIColour
  }
}

// MARK: - Primitive Colour
extension PrimitiveColour: ColourConvertible {
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    environment: EnvironmentValues? = nil
  ) -> Color {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    ).swiftUIColour
  }
}
