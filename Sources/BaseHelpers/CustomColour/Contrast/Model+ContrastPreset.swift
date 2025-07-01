//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

public enum ContrastPreset: String, CaseIterable, Identifiable {
  case subtle
  case moderate
  case standard
  case highContrast

  public var id: String { rawValue }

  public var name: String {
    switch self {
      case .subtle: "Subtle"
      case .moderate: "Moderate"
      case .standard: "Standard"
      case .highContrast: "High Contrast"
    }
  }

  package var adjustmentStrength: Double {
    switch self {
      case .subtle: 0.2
      case .moderate: 0.4
      case .standard: 0.75
      case .highContrast: 1.0
    }
  }

  public func adjustment(
    for level: LuminanceLevel,
    purpose: ContrastPurpose
  ) -> HSVAdjustment {
    HSVAdjustment.adjustment(
      forLumaLevel: level,
      contrastAmount: self.adjustmentStrength,
      purpose: purpose
    )
  }
}
