//
//  Model+Brightness.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/9/2025.
//

import Foundation

public enum ColourBrightness: Sendable, CaseIterable, Identifiable, HSVModifier {
  public static let allCases: [ColourBrightness] = [.bright, .standard, .dim]
  case bright
  case standard
  case dim
  case custom(Double)

  public var id: String { name }

  public var name: String {
    switch self {
      case .bright: "Bright"
      case .standard: "Standard"
      case .dim: "Dim"
      case .custom(let value): "Custom: \(value)"
    }
  }
  public var adjustment: HSVAdjustment {
    switch self {
      case .bright: HSVAdjustment(v: 0.3)
      case .standard: HSVAdjustment(v: 0)
      case .dim: HSVAdjustment(v: -0.2)
      case .custom(let value): HSVAdjustment(v: value)
    }
  }
}
