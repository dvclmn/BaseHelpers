//
//  ColourConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

/// The goal here is to unify some common colour-related types,
/// namely SwiftUI's `Color`, my `RGBColour`,
/// `NamedColour`, `PrimitiveColour` and `Swatch`.
public protocol ColourConvertible: Sendable, Identifiable {
  var id: Self.ID { get }
  var colourName: String? { get }
  var swiftUIColour: Color { get }

  func rgbColour(_ environment: EnvironmentValues) -> RGBColour
  
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
extension ColourConvertible {
  public var isVibrant: Bool {
    guard self is Swatch else { return false }
    return self.isVibrant
  }
  public var shadeNumber: Int? {
    guard self is Swatch else { return nil }
    return self.shadeNumber
  }
}

// MARK: - Color
extension Color: @retroactive Identifiable {
  public var id: Int { self.hashValue }
}

extension Color: ColourConvertible {

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour {
    //    guard let environment else { return nil }
    return RGBColour(colour: self, environment: environment)
  }
  //  public var id: String { self.description }
  public var swiftUIColour: Color { self }
  
//  public var name: String? { nil }
  
  public var colourName: String? {
    switch self {
      case .red: "Red"
      case .blue: "Blue"
      case .green: "Green"
      case .orange: "Orange"
      case .yellow: "Yellow"
      case .pink: "Pink"
      case .purple: "Purple"
      case .indigo: "Indigo"
      case .mint: "Mint"
      case .cyan: "Cyan"
      case .brown: "Brown"
      case .gray: "Gray"
      case .black: "Black"
      case .white: "White"
      case .clear: "Clear"
      case .primary: "Primary"
      case .secondary: "Secondary"
      case .accentColor: "Accent"
      default: nil
    }
  }
  
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
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

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues?
  ) -> Color {
    guard let modification else { return self }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }
}

// MARK: - RGBColour
extension RGBColour: ColourConvertible {

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour {
    return self
    //    guard let environment else { return nil }
    //    return RGBColour(colour: self, environment: environment)
  }

  public var colourName: String? { nil }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues? = nil
  ) -> Color {
    return self.contrastColour(strength: strength, purpose: purpose, chroma: chroma).swiftUIColour
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues?
  ) -> Color {
    guard let modification else { return self.swiftUIColour }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }

}

// MARK: - Swatch
extension Swatch: ColourConvertible {

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour {
    //    guard let environment else { return nil }
    return self.toRGB(environment)
  }

  public var colourName: String? { rawValue }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues? = nil
  ) -> Color {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    ).swiftUIColour
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues?
  ) -> Color {
    guard let modification else { return self.swiftUIColour }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }
}

// MARK: - Primitive Colour
extension PrimitiveColour: ColourConvertible {

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour {
    //    guard let environment else { return self.swiftUIColour.rgbColour(environment) }
    //    return RGBColour(colour: self, environment: environment)

    RGBColour(colour: self.swiftUIColour, environment: environment)
  }
  public var colourName: String? { rawValue.capitalized }
  
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues? = nil
  ) -> Color {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    ).swiftUIColour
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues?
  ) -> Color {
    guard let modification else { return self.swiftUIColour }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }
}
