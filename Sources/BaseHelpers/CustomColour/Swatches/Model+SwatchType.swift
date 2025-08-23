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
  case other(String?) // Can provide custom name

  public init(
    fromRawString raw: String,
    fallbackType: String? = nil
  ) {
    let lower = raw.lowercased()
    
    if lower.hasPrefix("ascii") {
      self = .ascii
    }
    else if let shade = SwatchShade(rawValue: lower) {
      self = .shade(shade)
    }
    else if lower.hasPrefix("neon") {
      self = .neon
    }
    else {
      self = .other(fallbackType)
    }
  }
  
  public var name: String {
    switch self {
      case .ascii:
        "ASCII"
      case .shade(let shade):
        shade.rawValue.capitalized
      case .neon:
        "Neon"
      case .other(let name):
        name ?? "Unknown"
    }
  }
}

public enum SwatchShade: String {
  case white
  case black
  case grey
}
