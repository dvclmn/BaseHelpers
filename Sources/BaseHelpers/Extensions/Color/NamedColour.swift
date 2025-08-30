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
  
  public static let red = NamedColour(Color.red, name: "Red")
  public static let blue = NamedColour(Color.blue, name: "Blue")
  public static let green = NamedColour(Color.green, name: "Green")
  public static let orange = NamedColour(Color.orange, name: "Orange")
  public static let yellow = NamedColour(Color.yellow, name: "Yellow")
  public static let pink = NamedColour(Color.pink, name: "Pink")
  public static let purple = NamedColour(Color.purple, name: "Purple")
  public static let indigo = NamedColour(Color.indigo, name: "Indigo")
  public static let mint = NamedColour(Color.mint, name: "Mint")
  public static let cyan = NamedColour(Color.cyan, name: "Cyan")
  public static let brown = NamedColour(Color.brown, name: "Brown")
  public static let gray = NamedColour(Color.gray, name: "Gray")
  public static let black = NamedColour(Color.black, name: "Black")
  public static let white = NamedColour(Color.white, name: "White")
  public static let clear = NamedColour(Color.clear, name: "Clear")
  public static let primary = NamedColour(Color.primary, name: "Primary")
  public static let secondary = NamedColour(Color.secondary, name: "Secondary")
  public static let accentColor = NamedColour(Color.accentColor, name: "Accent")
  
  public static var allCases: [NamedColour] {
    [
      red, blue, green, orange, yellow, pink, purple, indigo, mint, cyan,
      brown, gray, black, white, clear, primary, secondary, accentColor,
    ]
  }
}
