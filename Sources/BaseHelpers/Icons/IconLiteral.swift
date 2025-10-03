//
//  IconLiteral.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public enum IconLiteral: Sendable, Equatable, Codable, Hashable, ExpressibleByStringLiteral {
  case emoji(String)
  case symbol(String)
  case customSymbol(CustomSymbol)
  
  /// Have chosen `IconLiteral.symbol` as the
  /// most logical path for a string literal init
  public init(stringLiteral value: String) {
    self = .symbol(value)
  }
  
  public var toString: String {
    switch self {
      case .emoji(let string):
        return string
      case .symbol(let string):
        return string
      case .customSymbol(let symbol):
        return symbol.reference
    }
  }
}
