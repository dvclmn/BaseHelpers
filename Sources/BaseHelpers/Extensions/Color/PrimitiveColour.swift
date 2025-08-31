//
//  PrimitiveColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

/// This is referring to basic colours like "red" and "green",
/// as opposed to fancy shades like "peach" or "teal"
public enum PrimitiveColour: String, Identifiable, CaseIterable, Sendable, Comparable {

  case red
  case orange
  case yellow
  case green
  case blue
  case purple
  case pink
  case brown
  case grey
  case black
  case white
  case none

  public init?(fromSwatch swatch: Swatch) {
    let lower = swatch.rawValue.lowercased()

    guard let match = PrimitiveColour.allCases.first(where: { lower.contains($0.rawValue) }) else {
      return nil
    }
    self = match
  }
  public var name: String { rawValue.capitalized }
  
  public var id: String { rawValue }

  public var sortIndex: Int {
    PrimitiveColour.allCases.firstIndex(of: self) ?? 0
  }

  public static func < (lhs: PrimitiveColour, rhs: PrimitiveColour) -> Bool {
    lhs.sortIndex < rhs.sortIndex
  }

  /// Realised this seems redundant? Surely I've already got
  /// access to a name here, so no use for named colour?
//  public var namedColour: NamedColour? {
//    swiftUIColour.namedColour
//  }

  public var swiftUIColour: Color {
    switch self {
      case .red: Color.red
      case .orange: Color.orange
      case .yellow: Color.yellow
      case .green: Color.green
      case .blue: Color.blue
      case .purple: Color.purple
      case .pink: Color.pink
      case .brown: Color.brown
      case .grey: Color.gray
      case .black: Color.black
      case .white: Color.white
      case .none: Color.clear
    }
  }
}
