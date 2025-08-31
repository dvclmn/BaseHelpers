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
//public struct NamedColour: Sendable, Hashable, Equatable {
//  public let colour: any ColourConvertible
//  public let name: String
//
//  public init(_ colour: any ColourConvertible, name: String) {
//    self.colour = colour
//    self.name = name
//  }
//
//  public func hash(into hasher: inout Hasher) {
//    hasher.combine(name)
//  }
//
//  public static func == (lhs: NamedColour, rhs: NamedColour) -> Bool {
//    return lhs.name == rhs.name
//  }
//}

//public enum SwiftUIColour: Sendable, CaseIterable, Hashable, Equatable {
//  case red
//  case blue
//  case green
//  case orange
//  case yellow
//  case pink
//  case purple
//  case indigo
//  case mint
//  case cyan
//  case brown
//  case gray
//  case black
//  case white
//  case clear
//  case primary
//  case secondary
//  case accentColor
//
//  public var name: String {
//    switch self {
//      case .red: "Red"
//      case .blue: "Blue"
//      case .green: "Green"
//      case .orange: "Orange"
//      case .yellow: "Yellow"
//      case .pink: "Pink"
//      case .purple: "Purple"
//      case .indigo: "Indigo"
//      case .mint: "Mint"
//      case .cyan: "Cyan"
//      case .brown: "Brown"
//      case .gray: "Gray"
//      case .black: "Black"
//      case .white: "White"
//      case .clear: "Clear"
//      case .primary: "Primary"
//      case .secondary: "Secondary"
//      case .accentColor: "Accent"
//    }
//  }
//  public var swiftUIColour: Color {
//    switch self {
//      case .red: Color.red
//      case .blue: Color.blue
//      case .green: Color.green
//      case .orange: Color.orange
//      case .yellow: Color.yellow
//      case .pink: Color.pink
//      case .purple: Color.purple
//      case .indigo: Color.indigo
//      case .mint: Color.mint
//      case .cyan: Color.cyan
//      case .brown: Color.brown
//      case .gray: Color.gray
//      case .black: Color.black
//      case .white: Color.white
//      case .clear: Color.clear
//      case .primary: Color.primary
//      case .secondary: Color.secondary
//      case .accentColor: Color.accentColor
//    }
//  }
//}
