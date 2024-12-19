//
//  BinaryFloatingPoint.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation


public extension Double {
  /// Adds leading padding to align numbers based on their integer part
  /// - Parameters:
  ///   - maxDigits: Maximum number of digits to pad to
  ///   - padChar: Character to use for padding (default: space)
  /// - Returns: String with appropriate padding
  func padLeading(
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
    
    // Split into components, handling the negative sign
    let absNumberStr = isNegative ? String(formattedNumber.dropFirst()) : formattedNumber
    let components = absNumberStr.split(separator: ".", maxSplits: 1)
    let integerPart = String(components[0])
    let decimalPart = components.count > 1 ? "." + components[1] : ""
    
    // Calculate padding needed, accounting for negative sign
    let effectiveLength = integerPart.count + (isNegative ? 1 : 0)
    let padding = String(repeating: padChar, count: max(0, maxDigitsIncludingNegativeSign - effectiveLength))
    
    // Reconstruct the string with proper padding and sign
    if isNegative {
      return padding + "-" + integerPart + decimalPart
    } else {
      return padding + integerPart + decimalPart
    }
  }
  

}

public extension CGFloat {
  
  func padLeading(maxDigits: Int, decimalPlaces: Int? = nil, with padChar: Character = " ") -> String {
    Double(self).padLeading(maxDigits: maxDigits, decimalPlaces: decimalPlaces,  with: padChar)
  }
  
  
  
  var isPositive: Bool {
    self > 0
  }
  
  func normalised(against value: CGFloat, isClamped: Bool = true) -> CGFloat {
    let normalised = self / value
    
    return normalised
  }
  
}

public extension CGSize {
  var widthOrHeightIsZero: Bool {
    return self.width.isZero || self.height.isZero
  }
}
