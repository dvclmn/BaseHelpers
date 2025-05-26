//
//  IconLiteral.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import Foundation

public enum IconLiteral: Sendable, Equatable, Codable, Hashable {
  case emoji(String)
  case symbol(String)
  
  public var string: String {
    switch self {
      case .emoji(let string):
        return string
      case .symbol(let string):
        return string
    }
  }
}
