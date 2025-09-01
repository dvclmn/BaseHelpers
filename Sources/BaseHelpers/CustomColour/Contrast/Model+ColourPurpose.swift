//
//  Model+ColourPurpose.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import Foundation

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
