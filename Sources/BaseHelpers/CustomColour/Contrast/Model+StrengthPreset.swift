//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

/// Describes discrete steps from 0–1 for Colour modifications
public enum ModificationStrengthPreset: CaseIterable, Identifiable, Sendable {

  public static let allCases: [Self] = [
    .none,
    .subtle,
    .moderate,
    .standard,
    .highContrast,
  ]

  case none
  case subtle
  case moderate
  case standard
  case highContrast
  case custom(Double)

  public var id: String { name }

  public var name: String {
    switch self {
      case .none: "None"
      case .subtle: "Subtle"
      case .moderate: "Moderate"
      case .standard: "Standard"
      case .highContrast: "High Contrast"
      case .custom(let strength): "Custom (\(strength.displayString))"
    }
  }
  public var nameAbbreviated: String {
    switch self {
      case .none: "—"
      case .subtle: "Subt."
      case .moderate: "Mod."
      case .standard: "Std."
      case .highContrast: "Hi-Con."
      case .custom(let strength): "\(strength.displayString)"
    }
  }
  
  public var percentString: String {
    let value: CGFloat = adjustmentStrength * 100
    return value.displayString(.fractionLength(0)) + "%"
  }

  public var adjustmentStrength: Double {
    switch self {
      case .none: 0.0
      case .subtle: 0.2
      case .moderate: 0.4
      case .standard: 0.75
      case .highContrast: 1.0
      case .custom(let strength): strength
    }
  }
}
