//
//  Model+PrimitiveColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import SwiftUI

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
  case grey
  case black
  case white

  public init?(fromSwatch swatch: Swatch) {
    let lower = swatch.rawValue.lowercased()

    guard let match = PrimitiveColour.allCases.first(where: { lower.contains($0.rawValue) }) else {
      return nil
    }
    self = match
  }

  public var id: String { rawValue }

  public var sortIndex: Int {
    PrimitiveColour.allCases.firstIndex(of: self) ?? 0
  }
  
  public var colourName: String {
    self.swiftUIColour.
  }
//  public var namedColour: NamedColour {
//    switch self {
//      case .red:
//        NamedColour(colour: <#T##Color#>, name: <#T##String#>)
//      case .orange:
//        <#code#>
//      case .yellow:
//        <#code#>
//      case .green:
//        <#code#>
//      case .blue:
//        <#code#>
//      case .purple:
//        <#code#>
//      case .pink:
//        <#code#>
//      case .brown:
//        <#code#>
//      case .grey:
//        <#code#>
//      case .black:
//        <#code#>
//      case .white:
//        <#code#>
//    }
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
    }
  }
  
//  public var namedColour: Color {
//    switch self {
//      case .red: Color.red
//      case .orange: Color.orange
//      case .yellow: Color.yellow
//      case .green: Color.green
//      case .blue: Color.blue
//      case .purple: Color.purple
//      case .pink: Color.pink
//      case .brown: Color.brown
//      case .grey: Color.gray
//      case .black: Color.black
//      case .white: Color.white
//    }
//  }
}
