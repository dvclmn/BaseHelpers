//
//  QuickLabel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import Foundation
import BaseStyles

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
    
    var colour: Swatch {
      switch self {
        case .success: .asciiGreen
        case .destructive: .asciiRed
        case .warning: .asciiYellow
      }
    }
  }
}


//extension QuickLabel {
//
//  static func statusLabel(_ isConnected: Bool) -> Self {
//    isConnected ? QuickLabel("Connected", "checkmark") : QuickLabel("Not Connected", "wifi.slash")
//  }
//}
