//
//  QuickLabel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import SwiftUI

public enum IconLiteral: Sendable, Equatable, Codable, Hashable {
  case emoji(String)
  case symbol(String)
  
  public var toString: String {
    switch self {
      case .emoji(let string):
        return string
      case .symbol(let string):
        return string
    }
  }
}

public struct QuickLabel: Equatable, Hashable, Sendable, Codable {
  public let attributedText: AttributedString
  public let icon: IconLiteral?
  public let role: Role?
  
  public var text: String {
    return attributedText.toString
  }
  
  public static let blank: QuickLabel = .init("")
  
  public init(
    _ text: String,
    _ icon: IconLiteral? = nil,
    role: Role? = nil
  ) {
    self.attributedText = AttributedString(text)
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

extension QuickLabel: CustomStringConvertible {
  public var description: String {
    return "QuickLabel[\"\(text)\", icon: \"\(icon?.toString ?? "")\"]"
  }
}
