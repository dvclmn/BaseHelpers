//
//  QuickLabel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import SwiftUI

public struct QuickLabel: ModelBase {
  public let text: String
  //  public var attributedText: AttributedString
  public let icon: IconLiteral?
  public let role: Role?

  //  public var text: String {
  //    return String(attributedText.characters)
  //  }
}

// MARK: - Initialisers
extension QuickLabel {

  public init(
    _ text: String,
    _ icon: IconLiteral? = nil,
    role: Role? = nil
  ) {
    //    self.attributedText = AttributedString(text)
    self.icon = icon
    self.role = role
  }

  public init(
    _ text: AttributedString,
    icon: IconLiteral? = nil,
    role: Role? = nil
  ) {
    //    self.attributedText = text
    self.icon = icon
    self.role = role
  }

  public init(
    _ text: AttributedString,
    iconString: String? = nil,
    role: Role? = nil
  ) {
    self.attributedText = text
    if let iconString {
      self.icon = .symbol(iconString)
    } else {
      self.icon = nil
    }
    self.role = role
  }

  public init(
    _ text: String,
    _ icon: String,
    role: Role? = nil
  ) {
    self.attributedText = AttributedString(text)
    self.icon = IconLiteral.symbol(icon)
    self.role = role
  }

  public init(
    _ bool: Bool,
    _ textTrue: String,
    _ iconTrue: IconLiteral? = nil,
    _ textFalse: String = "",
    _ iconFalse: IconLiteral? = nil,
    role: Role? = nil
  ) {
    if bool {
      self.attributedText = AttributedString(textTrue)
      self.icon = iconTrue
    } else {
      self.attributedText = AttributedString(textFalse)
      self.icon = iconFalse
    }
    self.role = role
  }
}

extension QuickLabel: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
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
