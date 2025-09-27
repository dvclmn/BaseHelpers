//
//  QuickLabel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import SwiftUI

public struct QuickLabel: ModelBase {
//  public let text: String
    public var attributedText: AttributedString
  public let icon: IconLiteral?
  public let role: Role?

    public var text: String {
      return String(attributedText.characters)
    }
}

// MARK: - Initialisers
extension QuickLabel {

  public init(
    _ text: AttributedString,
//    _ text: String,
    icon: IconLiteral? = nil,
    role: Role? = nil
  ) {
    self.attributedText = text
    self.icon = icon
    self.role = role
  }

  /// This doesn't have a default of `nil` for `symbol`,
  /// to disambiguate from ``QuickLabel/init(_:icon:role:)``
  public init(
    _ text: AttributedString,
//    _ text: String,
    symbol symbolString: String?,
    role: Role? = nil
  ) {
    self.attributedText = text
    self.icon = symbolString.map { IconLiteral.symbol($0) }
    self.role = role
  }
}

extension QuickLabel {
  /// Turn this into a factory method at some point?
//  public init(
//    _ bool: Bool,
//    _ textTrue: String,
//    _ iconTrue: IconLiteral? = nil,
//    _ textFalse: String = "",
//    _ iconFalse: IconLiteral? = nil,
//    role: Role? = nil
//  ) {
//    if bool {
//      self.attributedText = AttributedString(textTrue)
//      self.icon = iconTrue
//    } else {
//      self.attributedText = AttributedString(textFalse)
//      self.icon = iconFalse
//    }
//    self.role = role
//  }
}

extension QuickLabel: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value.toAttributedString)
  }
}

extension QuickLabel: CustomStringConvertible {
  public var description: String {
    return "QuickLabel[\"\(text)\", icon: \"\(icon?.toString ?? "")\"]"
  }
}
extension QuickLabel {

  public enum Role: Equatable, Sendable, Codable {
    case success
    case destructive
    case warning

    var colour: Color {
      switch self {
        case .success: .green
        case .destructive: .red
        case .warning: .yellow
      }
    }
  }
}
