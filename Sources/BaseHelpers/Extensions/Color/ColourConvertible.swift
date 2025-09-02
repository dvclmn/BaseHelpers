//
//  ColourConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

/// The goal here is to unify some common colour-related types:
/// `Color` (native)
/// `RGBColour`
/// `Swatch`
public protocol ColourConvertible: Sendable, Identifiable {
  var id: Self.ID { get }
  var colourName: String? { get }
  var swiftUIColour: Color { get }
  var typeDescription: String { get }

  func rgbColour(_ environment: EnvironmentValues) -> RGBColour

  /// Includes optional `environment`, as `Color`
  /// needs this to resolve itself first. If `nil`, `Color`
  /// will return it's `self`, unmodified.
  func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma,
    environment: EnvironmentValues
  ) -> RGBColour

  func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues
  ) -> RGBColour

}

extension ColourConvertible {
  public var typeDescription: String {
    "ColourConvertible[Type: \(Self.Type.self), Name: \(colourName ?? "nil"), SwiftUI Color: \(swiftUIColour)]"
  }

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
    RGBColour(colour: self, environment: environment, name: self.colourName)
  }

  public var swiftUIColour: Color { self }

  public var colourName: String? {
    SystemColour(colour: self)?.colourName
  }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues
  ) -> RGBColour {
    let hsvColour = HSVColour(colour: self, environment: environment, name: nil)
    let adjustment = HSVAdjustment.applyingModifiers(
      for: hsvColour,
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )
    let adjustedHSV = hsvColour.applying(adjustment: adjustment)
    return adjustedHSV.toRGB
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues
  ) -> RGBColour {
    guard let modification else { return self.rgbColour(environment) }

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

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour { self }

  public var colourName: String? { name }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues
  ) -> RGBColour {
    return self.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues
  ) -> RGBColour {
    guard let modification else { return self }

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
    environment: EnvironmentValues
  ) -> RGBColour {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    )
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues
  ) -> RGBColour {
    guard let modification else { return self.toRGB(environment) }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }
}

// MARK: - System Colour
extension SystemColour: ColourConvertible {

  public func rgbColour(_ environment: EnvironmentValues) -> RGBColour {
    return self.swiftUIColour.rgbColour(environment)
  }

  public var colourName: String? { self.name }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .default,
    chroma: ColourChroma = .default,
    environment: EnvironmentValues
  ) -> RGBColour {

    return swiftUIColour.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma,
      environment: environment,
    )
  }

  public func contrastColour(
    modification: ColourModification?,
    environment: EnvironmentValues
  ) -> RGBColour {
    guard let modification else { return self.rgbColour(environment) }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma,
      environment: environment
    )
  }
}
