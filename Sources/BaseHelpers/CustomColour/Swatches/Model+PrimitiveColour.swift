//
//  Model+PrimitiveColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

/// This is referring to basic colours like "red" and "green",
/// as opposed to fancy shades like "peach" or "teal"
public enum PrimitiveColour: String, Identifiable, CaseIterable, Sendable, Comparable {
  public static func < (lhs: PrimitiveColour, rhs: PrimitiveColour) -> Bool {
    lhs.sortIndex < rhs.sortIndex
  }
  
  case red
  case orange
  case yellow
  case green
  case blue
  case purple
  case pink
  case brown
  case monochrome
  
  public init(fromSwatch swatch: Swatch) {
    
  }
  
  public var id: String { rawValue }

  public var sortIndex: Int {
    PrimitiveColour.allCases.firstIndex(of: self) ?? 0
  }
}
