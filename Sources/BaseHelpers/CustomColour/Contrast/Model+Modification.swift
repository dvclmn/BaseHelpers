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

/// Where `HSVAdjustment` models hue, saturation and brightness
/// levels to add to an `HSVColour`, `ColourModification`
/// models the *way* these values are added. Strength, saturation presets, etc.
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

extension ColourModification {
  public static func modificationFromOptionals(
    modification: ColourModification?,
    strength: ModificationStrengthPreset?,
    purpose: ColourPurpose?,
    chroma: ColourChroma?
  ) -> ColourModification {
    var newModification: ColourModification = .zero
    
    if let modification {
      newModification = modification
    }
    
    if let strength {
      newModification.strength = strength
    }
    
    if let purpose {
      newModification.purpose = purpose
    }
    
    if let chroma {
      newModification.chroma = chroma
    }
    
    return newModification
    
  }
}

extension ColourModification: CustomStringConvertible {
  public var description: String {
    "Strength: **\(strength.name)**\nPurpose: **\(purpose.name)**\nChroma: **\(chroma.name)**"
  }
}
