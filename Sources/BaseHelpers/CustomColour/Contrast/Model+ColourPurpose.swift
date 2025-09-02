//
//  Model+ColourPurpose.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import Foundation

public enum ColourPurpose: String, CaseIterable, Identifiable, Sendable, HSVModifier {
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
  
  public var adjustment: HSVAdjustment {
    switch self {
      case .legibility: HSVAdjustment(h: -0.6, s: -0.01, v: 0.1)
//      case .legibility: HSVAdjustment(h: -6, s: -0.01, v: 0.1)
      case .complementary: HSVAdjustment(h: -0.3, s: 0.1, v: 0.0)
//      case .complementary: HSVAdjustment(h: -3, s: 0.1, v: 0.0)
    }
  }
}
