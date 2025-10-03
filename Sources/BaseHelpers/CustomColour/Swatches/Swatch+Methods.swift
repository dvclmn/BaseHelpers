//
//  Swatch+Methods.swift
//  BaseStyles
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

extension Swatch {

  public var id: String { rawValue }
  
  public func toCodableColour(_ environment: EnvironmentValues?) -> CodableColour {
    return CodableColour(
      resolved: swiftUIColour.resolve(in: CodableColour.environmentOrDefault(environment)),
      name: name
    )
  }

  public func toRGB(_ environment: EnvironmentValues) -> RGBColour {
    let rgb = RGBColour(
      colour: self.swiftUIColour,
      environment: environment,
      name: self.name
    )
    return rgb
  }

  public var swiftUIColour: Color {
    Color("swatch/\(rawValue)", bundle: .module)
  }

  public var type: SwatchType {
    SwatchType(
      fromRawString: rawValue,
      fallbackType: "Base"
    )
  }
  
  public var name: String { rawValue }

  //  public func type(fallBackType: String? = nil) -> String {
  //    return SwatchType(fromRawString: rawValue, fallbackType: fallBackType).name
  //  }

  public var shadeNumber: Int? {
    let digits = self.rawValue.filter { $0.isWholeNumber }
    guard let result = Int(digits) else { return nil }
    return result
  }

  // MARK: - Grouping
  public var shadeString: String? {
    /// This should return the part of the Swatch case name
    /// that is a number, if present
    let digits = rawValue.filter { $0.isWholeNumber }
    guard !digits.isEmpty else { return nil }
    return digits
  }

  public static func grouped(includesAscii: Bool = false) -> [String: [Self]] {
    let swatches: [Swatch]
    if includesAscii {
      swatches = Self.allCases
    } else {
      swatches = Self.allCases.filter { swatch in
        !swatch.rawValue.contains("ascii")
      }
    }
    let grouped = Dictionary(grouping: swatches) { $0.type.name.full }
    return grouped
  }

  public var primitiveColour: PrimitiveColour? {
    PrimitiveColour(fromSwatch: self)
  }

  public var primitiveColourName: String {
    return primitiveColour?.rawValue ?? "Unknown"
  }

  public var isVibrant: Bool {
    return rawValue.hasSuffix("V")
  }

  
}

public enum BrightnessAdjustment {
  case darker
  case brighter

  public func adjustment(with value: CGFloat) -> CGFloat {
    switch self {
      case .darker:
        let result: CGFloat = value * -1
        return min(0, max(1, result))
      case .brighter:
        return min(0, max(1, value))
    }
  }
}
