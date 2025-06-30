//
//  Model+SwatchType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

public enum SwatchType {
  case ascii
  case shade(SwatchShade)
  case neon
  case base
  
  public var name: String {
    switch self {
      case .ascii:
        "ASCII"
      case .shade(let shade):
        shade.rawValue.capitalized
      case .neon:
        "Neon"
      case .base:
        "Base"
    }
  }
}

public enum SwatchShade: String {
  case white
  case black
}

