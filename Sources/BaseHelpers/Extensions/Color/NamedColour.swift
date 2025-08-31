//
//  NamedColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import SwiftUI

/// The goal for `NamedColour` is simply to tie any
/// useful name to a colour (`ColourConvertible`).
///
/// I chose this over a protocol
/// approach (requiring a `name` property on the
/// colours themselves), to keep this naming responsibility
/// separated from actual colour related internals.
public struct NamedColour: Sendable, CaseIterable, Hashable, Equatable {
  public let colour: any ColourConvertible
  public let name: String

  public init(_ colour: any ColourConvertible, name: String) {
    self.colour = colour
    self.name = name
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }

  public static func == (lhs: NamedColour, rhs: NamedColour) -> Bool {
    return lhs.name == rhs.name
  }

  //  public static let red = NamedColour(Color.red, name: "Red")
  //  public static let blue = NamedColour(Color.blue, name: "Blue")
  //  public static let green = NamedColour(Color.green, name: "Green")
  //  public static let orange = NamedColour(Color.orange, name: "Orange")
  //  public static let yellow = NamedColour(Color.yellow, name: "Yellow")
  //  public static let pink = NamedColour(Color.pink, name: "Pink")
  //  public static let purple = NamedColour(Color.purple, name: "Purple")
  //  public static let indigo = NamedColour(Color.indigo, name: "Indigo")
  //  public static let mint = NamedColour(Color.mint, name: "Mint")
  //  public static let cyan = NamedColour(Color.cyan, name: "Cyan")
  //  public static let brown = NamedColour(Color.brown, name: "Brown")
  //  public static let gray = NamedColour(Color.gray, name: "Gray")
  //  public static let black = NamedColour(Color.black, name: "Black")
  //  public static let white = NamedColour(Color.white, name: "White")
  //  public static let clear = NamedColour(Color.clear, name: "Clear")
  //  public static let primary = NamedColour(Color.primary, name: "Primary")
  //  public static let secondary = NamedColour(Color.secondary, name: "Secondary")
  //  public static let accentColor = NamedColour(Color.accentColor, name: "Accent")

//  public static var allCases: [NamedColour] {
//    [
//      red, blue, green, orange, yellow, pink, purple, indigo, mint, cyan,
//      brown, gray, black, white, clear, primary, secondary, accentColor,
//    ]
//  }
}

public enum SwiftUIColour: Sendable, CaseIterable, Hashable, Equatable {
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

  //  private var named: NamedColour {
  //    switch self {
  //      case .red: NamedColour(Color.red, name: "Red")
  //      case .blue: NamedColour(Color.blue, name: "Blue")
  //      case .green: NamedColour(Color.green, name: "Green")
  //      case .orange: NamedColour(Color.orange, name: "Orange")
  //      case .yellow: NamedColour(Color.yellow, name: "Yellow")
  //      case .pink: NamedColour(Color.pink, name: "Pink")
  //      case .purple: NamedColour(Color.purple, name: "Purple")
  //      case .indigo: NamedColour(Color.indigo, name: "Indigo")
  //      case .mint: NamedColour(Color.mint, name: "Mint")
  //      case .cyan: NamedColour(Color.cyan, name: "Cyan")
  //      case .brown: NamedColour(Color.brown, name: "Brown")
  //      case .gray: NamedColour(Color.gray, name: "Gray")
  //      case .black: NamedColour(Color.black, name: "Black")
  //      case .white: NamedColour(Color.white, name: "White")
  //      case .clear: NamedColour(Color.clear, name: "Clear")
  //      case .primary: NamedColour(Color.primary, name: "Primary")
  //      case .secondary: NamedColour(Color.secondary, name: "Secondary")
  //      case .accentColor: NamedColour(Color.accentColor, name: "Accent")
  //    }
  //  }

  public var name: String {
    switch self {
      case .red: "Red"
      case .blue: "Blue"
      case .green: "Green"
      case .orange: "Orange"
      case .yellow: "Yellow"
      case .pink: "Pink"
      case .purple: "Purple"
      case .indigo: "Indigo"
      case .mint: "Mint"
      case .cyan: "Cyan"
      case .brown: "Brown"
      case .gray: "Gray"
      case .black: "Black"
      case .white: "White"
      case .clear: "Clear"
      case .primary: "Primary"
      case .secondary: "Secondary"
      case .accentColor: "Accent"
    }
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
    //    self.named.colour.swiftUIColour
  }

}
