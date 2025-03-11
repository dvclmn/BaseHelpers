//
//  Double.swift
//  Collection
//
//  Created by Dave Coleman on 19/12/2024.
//

import Foundation

extension Double {
  
  public var panelOpacity: Double {
    let opacity = min(0.75, max(0.1, self))
    return opacity
  }
  
  /// Adds leading padding to align numbers based on their integer part
  /// - Parameters:
  ///   - maxDigits: Maximum number of digits to pad to
  ///   - padChar: Character to use for padding (default: space)
  /// - Returns: String with appropriate padding
  public func padLeading(
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {

    let maxDigitsIncludingNegativeSign = maxDigits + 1

    /// First handle decimal places if specified
    let numberToFormat = self
    let formattedNumber: String

    if let places = decimalPlaces {
      formattedNumber = numberToFormat.formatted(.number.precision(.fractionLength(places)))
    } else {
      formattedNumber = String(numberToFormat)
    }

    let isNegative = self < 0

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
