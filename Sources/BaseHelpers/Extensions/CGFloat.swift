//
//  CGFloat.swift
//  Collection
//
//  Created by Dave Coleman on 19/12/2024.
//

import Foundation

extension CGFloat {

  public var isPositive: Bool {
    self > 0
  }

  public func padLeading(
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {
    PadFloat.padLeading(
      value: self,
      maxDigits: maxDigits,
      decimalPlaces: decimalPlaces,
      with: padChar
    )
  }
//  public func padLeading(
//    maxDigits: Int, decimalPlaces: Int? = nil, with padChar: Character = " "
//  ) -> String {
//    Double(self).padLeading(maxDigits: maxDigits, decimalPlaces: decimalPlaces, with: padChar)
//  }

  public func normalised(against value: CGFloat, isClamped: Bool = true) -> CGFloat {
    let normalised = self / value

    return normalised
  }

  public var toFinite: CGFloat {
    self.constrained(.zero, .infinity)
  }

}

extension Double {
  public func padLeading(
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {
    PadFloat.padLeading(
      value: self,
      maxDigits: maxDigits,
      decimalPlaces: decimalPlaces,
      with: padChar
    )
  }
}

struct PadFloat {
  
  /// Adds leading padding to align numbers based on their integer part
  static func padLeading(
    value: Double,
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {
    
    let maxDigitsIncludingNegativeSign = maxDigits + 1
    
    /// First handle decimal places if specified
    let numberToFormat = value
    let formattedNumber: String
    
    if let places = decimalPlaces {
      formattedNumber = numberToFormat.formatted(.number.precision(.fractionLength(places)))
    } else {
      formattedNumber = String(numberToFormat)
    }
    
    let isNegative = numberToFormat < 0
    
    /// Split into components, handling the negative sign
    let absNumberStr = isNegative ? String(formattedNumber.dropFirst()) : formattedNumber
    let components = absNumberStr.split(separator: ".", maxSplits: 1)
    let integerPart = String(components[0])
    let decimalPart = components.count > 1 ? "." + components[1] : ""
    
    /// Calculate padding needed, accounting for negative sign
    let effectiveLength = integerPart.count + (isNegative ? 1 : 0)
    let padding = String(repeating: padChar, count: max(0, maxDigitsIncludingNegativeSign - effectiveLength))
    
    /// Reconstruct the string with proper padding and sign
    guard isNegative else {
      return padding + integerPart + decimalPart
    }
    return padding + "-" + integerPart + decimalPart
  }
  
}
