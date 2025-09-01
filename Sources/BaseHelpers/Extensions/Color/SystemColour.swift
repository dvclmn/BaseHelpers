//
//  SystemColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/9/2025.
//

import SwiftUI

public enum SystemColour: String, CaseIterable, Identifiable, Sendable {
  case red
  case blue
  case green
  case orange
  case yellow
  case pink
  case purple
  case indigo
  case mint
  case cyan
  case brown
  case gray
  case black
  case white
  case clear
  case primary
  case secondary
  case accentColor

  public init?(colour: Color) {
    let result: Self? =
      switch colour {
        case .red: SystemColour.red
        case .blue: SystemColour.blue
        case .green: SystemColour.green
        case .orange: SystemColour.orange
        case .yellow: SystemColour.yellow
        case .pink: SystemColour.pink
        case .purple: SystemColour.purple
        case .indigo: SystemColour.indigo
        case .mint: SystemColour.mint
        case .cyan: SystemColour.cyan
        case .brown: SystemColour.brown
        case .gray: SystemColour.gray
        case .black: SystemColour.black
        case .white: SystemColour.white
        case .clear: SystemColour.clear
        case .primary: SystemColour.primary
        case .secondary: SystemColour.secondary
        case .accentColor: SystemColour.accentColor
        default: nil
      }
    guard let result else { return nil }
    self = result
  }

  public var id: String { rawValue }

  public var name: String {
    switch self {
      case .accentColor: "Accent"
      default: rawValue.capitalized
    }
  }
  
  public var toPrimitiveColour: PrimitiveColour? {
    PrimitiveColour(rawValue: self.rawValue)
  }

  public var swiftUIColour: Color {
    switch self {
      case .red: Color.red
      case .blue: Color.blue
      case .green: Color.green
      case .orange: Color.orange
      case .yellow: Color.yellow
      case .pink: Color.pink
      case .purple: Color.purple
      case .indigo: Color.indigo
      case .mint: Color.mint
      case .cyan: Color.cyan
      case .brown: Color.brown
      case .gray: Color.gray
      case .black: Color.black
      case .white: Color.white
      case .clear: Color.clear
      case .primary: Color.primary
      case .secondary: Color.secondary
      case .accentColor: Color.accentColor
    }
  }
}
