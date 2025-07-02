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

public struct QuickLabel: Equatable, Sendable, Codable {
  public let text: String
  public let icon: IconLiteral?
  public let role: Role?
  
  public static let blank: QuickLabel = .init("")
  
  public init(
    _ text: String,
    _ icon: IconLiteral? = nil,
    role: Role? = nil
  ) {
    self.text = text
    self.icon = icon
    self.role = role
  }
  
  public init(
    _ text: String,
    _ icon: String,
    role: Role? = nil
  ) {
    self.text = text
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
      self.text = textTrue
      self.icon = iconTrue
    } else {
      self.text = textFalse
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
