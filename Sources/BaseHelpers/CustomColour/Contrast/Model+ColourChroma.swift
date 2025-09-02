//
//  Model+ColourChroma.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import Foundation

public enum ColourChroma: Sendable, CaseIterable, Identifiable, HSVModifier {
  public static let allCases: [ColourChroma] = [
    .vibrant,
    .saturated,
    .standard,
    .dull,
    .monochrome
  ]
  
  case vibrant
  case saturated
  case standard
  case dull
  case monochrome
  case custom(Double)
  
  public var id: String { name }
  
  public var name: String {
    switch self {
      case .vibrant: "Vibrant"
      case .saturated: "Saturated"
      case .standard: "Standard"
      case .dull: "Dull"
      case .monochrome: "Monochrome"
      case .custom(let value): "Custom: \(value)"
    }
  }
  
  public var nameAbbreviated: String {
    switch self {
      case .vibrant: "Vibr"
      case .saturated: "Sat"
      case .standard: "Std"
      case .dull: "Dull"
      case .monochrome: "Mono"
      case .custom(let value): "\(value)"
    }
  }
  public static let `default`: Self = .standard
  
  public var adjustment: HSVAdjustment {
    switch self {
      case .vibrant: HSVAdjustment(s: 0.7)
      case .saturated: HSVAdjustment(s: 0.4)
      case .standard: HSVAdjustment(s: 0)
      case .dull: HSVAdjustment(s: -0.35)
      case .monochrome: HSVAdjustment(s: -1.0)
      case .custom(let value): HSVAdjustment(s: value)
    }
  }
}
