//
//  Model+LumaLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import SwiftUI

extension EnvironmentValues {
  @Entry public var colourModification: ColourModification? = nil
  @Entry public var colourModificationStrength: ModificationStrengthPreset? = nil
  @Entry public var colourPurpose: ColourPurpose? = nil
  @Entry public var colourChroma: ColourChroma? = nil
}

public struct ColourModification: Sendable {
  public var strength: ModificationStrengthPreset
  public var purpose: ColourPurpose
  public var chroma: ColourChroma

  public init(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose,
    chroma: ColourChroma
  ) {
    self.strength = strength
    self.purpose = purpose
    self.chroma = chroma
  }
  
  public static let zero: ColourModification = .init(
    strength: .none,
    purpose: .default,
    chroma: .default
  )

  public static let `default`: ColourModification = .init(
    strength: .default,
    purpose: .default,
    chroma: .default
  )
}

//extension ColourModification {
//
//}

extension ColourModification: CustomStringConvertible {
  public var description: String {
    "Strength: **\(strength.name)**\nPurpose: **\(purpose.name)**\nChroma: **\(chroma.name)**"
  }
}

public enum ColourPurpose: String, CaseIterable, Identifiable, Sendable {
  case legibility
  case complementary

  public var id: String { rawValue }
  public var name: String { rawValue.capitalized }
  public var nameAbbreviated: String {
    switch self {
      case .legibility: "Legi"
      case .complementary: "Comp"
    }
  }
  public static let `default`: Self = .legibility

  var adjustment: HSVAdjustment {
    switch self {
      case .legibility: HSVAdjustment(-6, -0.01, 0.1)
      case .complementary: HSVAdjustment(-3, 0.1, 0.0)
    }
  }
}

public enum ColourChroma: String, Sendable, CaseIterable, Identifiable {
  case vibrant
  case saturated
  case standard
  case monochrome

  public var id: String { rawValue }
  public var name: String { rawValue.capitalized }

  public var nameAbbreviated: String {
    switch self {
      case .vibrant: "Vibr"
      case .saturated: "Sat"
      case .standard: "Std"
      case .monochrome: "Mono"
    }
  }
  public static let `default`: Self = .standard

  public var adjustment: HSVAdjustment {
    switch self {
      case .vibrant: HSVAdjustment(0, 0.7, 0)
      case .saturated: HSVAdjustment(0, 0.4, 0)
      case .standard: .zero
      case .monochrome: HSVAdjustment(0, -1.0, 0)
    }
  }
}
