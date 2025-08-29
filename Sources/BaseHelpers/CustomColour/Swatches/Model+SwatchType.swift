//
//  Model+SwatchType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

public enum SwatchType {
  case ascii
  /// Primitive colour may be a better thing anyway
  //  case shade(SwatchShade)
  case monochrome
  case neon
  case other(String?)  // Can provide custom name

  public init(
    fromRawString raw: String,
    fallbackType: String? = nil
  ) {
    let rawString = raw.lowercased()

    if rawString.contains("ascii") {
      print("Found an ASCII swatch: \(raw)")
      self = .ascii
    } else if rawString.contains("neon") {
      print("Found a Neon swatch: \(raw)")
      self = .neon
    } else if rawString.contains("grey") || rawString.contains("gray") || rawString.contains("black")
      || rawString.contains("white")
    {
      print("Found a monochrome swatch: \(raw)")
      self = .monochrome
    } else {
      print("Swatch type not recognised for \(raw); fallback is \(fallbackType ?? "Not supplied")")
      self = .other(fallbackType)

    }

    //    if SwatchShade.allCases.contains(where: { shade in
    //      rawString.contains(shade.rawValue)
    //    }) {
    //      self == .shade(SwatchShade(rawValue: <#T##String#>))
    //    }
    //    let possibleShades = SwatchShade.allCases
    //    print("Possible shades: \(possibleShades)")

    //    } else if let shade = SwatchShade(rawValue: lower) {
    //      print("Found a swatch with shade \(shade.rawValue) (raw: \(raw))")
    //      self = .shade(shade)
    //
    //    } else if lower.hasPrefix("neon") {
    //      print("Found a Neon swatch: \(raw)")
    //      self = .neon
    //
    //    } else {
    //      print("Swatch type not recognised; fallback is \(fallbackType ?? "Not supplied"), raw is \(raw)")
    //      self = .other(fallbackType)
    //    }
  }

  public var name: String {
    switch self {
      case .ascii:
        "ASCII"
      case .monochrome:
        "Monochrome"
      //      case .shade(let shade):
      //        shade.rawValue.capitalized
      case .neon:
        "Neon"
      case .other(let name):
        name ?? "Unknown"
    }
  }
}

//public enum SwatchShade: String, CaseIterable {
//  case white
//  case black
//  case grey
//}
