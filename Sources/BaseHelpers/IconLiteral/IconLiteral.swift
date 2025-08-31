//
//  IconLiteral.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public enum IconLiteral: Sendable, Equatable, Codable, Hashable {
  case emoji(String)
  case symbol(String)
  case customSymbol(CustomSymbol)
  
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
