//
//  Model+ColourChroma.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import Foundation

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
      case .vibrant: HSVAdjustment(h: 0, s: 0.7, v: 0)
      case .saturated: HSVAdjustment(h: 0, s: 0.4, v: 0)
      case .standard: .zero
      case .monochrome: HSVAdjustment(h: 0, s: -1.0, v: 0)
    }
  }
}
